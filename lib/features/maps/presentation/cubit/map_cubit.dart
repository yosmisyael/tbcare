import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';
import 'package:TBConsult/features/maps/domain/usecases/facility_usecases.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final GetFacilitiesUseCase getFacilitiesUseCase;
  final GetRouteUseCase getRouteUseCase;

  MapCubit({
    required this.getFacilitiesUseCase,
    required this.getRouteUseCase,
  }) : super(const MapInitial());

  // ── Initialise ──────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    emit(const MapLoading());
    try {
      final location = await _requestLocation();
      final facilities = await getFacilitiesUseCase(
        GetFacilitiesParams(userLocation: location),
      );
      emit(MapLoaded(
        allFacilities: facilities,
        filteredFacilities: facilities,
        activeFilters: const {},
        searchQuery: '',
        userLocation: location,
      ));
    } catch (e) {
      emit(MapError(message: e.toString()));
    }
  }

  // ── Search ──────────────────────────────────────────────────────────────────

  void search(String query) {
    final current = _loaded;
    if (current == null) return;
    final updated = current.copyWith(
      searchQuery: query,
      filteredFacilities: _applyFilters(
        current.allFacilities,
        current.activeFilters,
        query,
      ),
      clearRoute: true,
      clearSelectedFacility: true,
    );
    emit(updated);
  }

  // ── Filters ─────────────────────────────────────────────────────────────────

  void setFilters(Set<FacilityType> filters) {
    final current = _loaded;
    if (current == null) return;
    emit(current.copyWith(
      activeFilters: filters,
      filteredFacilities: _applyFilters(
        current.allFacilities,
        filters,
        current.searchQuery,
      ),
      clearRoute: true,
      clearSelectedFacility: true,
    ));
  }

  // ── Facility selection ──────────────────────────────────────────────────────

  void selectFacility(FacilityEntity facility) {
    final current = _loaded;
    if (current == null) return;
    emit(current.copyWith(
      selectedFacility: facility,
      clearRoute: true,
    ));
  }

  void clearSelection() {
    final current = _loaded;
    if (current == null) return;
    emit(current.copyWith(clearSelectedFacility: true, clearRoute: true));
  }

  // ── Navigation / Route ──────────────────────────────────────────────────────

  Future<void> navigateTo(FacilityEntity facility) async {
    final current = _loaded;
    if (current == null) return;
    if (current.userLocation == null) {
      emit(const MapError(message: 'Lokasi GPS tidak tersedia'));
      return;
    }

    emit(MapRoutingLoading(current));
    try {
      final points = await getRouteUseCase(GetRouteParams(
        origin: current.userLocation!,
        destination: LatLng(facility.lat, facility.lng),
      ));
      emit(current.copyWith(
        routePoints: points,
        selectedFacility: facility,
      ));
    } catch (e) {
      emit(current.copyWith()); // restore state
      emit(MapError(message: 'Gagal mengambil rute: ${e.toString()}'));
    }
  }

  // ── GPS ─────────────────────────────────────────────────────────────────────

  Future<void> recenterToUser() async {
    final current = _loaded;
    if (current?.userLocation != null) return; // already have it
    try {
      final location = await _requestLocation();
      if (current != null && location != null) {
        emit(current.copyWith(userLocation: location));
      }
    } catch (_) {}
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  MapLoaded? get _loaded {
    final s = state;
    if (s is MapLoaded) return s;
    if (s is MapRoutingLoading) return s.previous;
    return null;
  }

  List<FacilityEntity> _applyFilters(
      List<FacilityEntity> all,
      Set<FacilityType> filters,
      String query,
      ) {
    return all.where((f) {
      final matchesType = filters.isEmpty || filters.contains(f.type);
      final q = query.toLowerCase();
      final matchesQuery = q.isEmpty ||
          f.name.toLowerCase().contains(q) ||
          f.address.toLowerCase().contains(q);
      return matchesType && matchesQuery;
    }).toList();
  }

  Future<LatLng?> _requestLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }
}
