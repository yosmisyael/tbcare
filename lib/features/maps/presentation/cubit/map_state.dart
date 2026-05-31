import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  /// All facilities (unfiltered master list).
  final List<FacilityEntity> allFacilities;

  /// Currently visible facilities after search + filter.
  final List<FacilityEntity> filteredFacilities;

  /// Active type filter; empty = all types shown.
  final Set<FacilityType> activeFilters;

  /// Current search query string.
  final String searchQuery;

  /// Max distance filter in km; null = no distance filter.
  final double? maxDistanceKm;

  /// Minimum rating filter (0–5).
  final double minRating;

  /// User's device location; null if not yet obtained.
  final LatLng? userLocation;

  /// Road-accurate polyline to the selected facility.
  final List<LatLng> routePoints;

  /// The facility the user tapped on (shown in bottom sheet).
  final FacilityEntity? selectedFacility;

  const MapLoaded({
    required this.allFacilities,
    required this.filteredFacilities,
    required this.activeFilters,
    required this.searchQuery,
    this.maxDistanceKm,
    this.minRating = 0.0,
    this.userLocation,
    this.routePoints = const [],
    this.selectedFacility,
  });

  MapLoaded copyWith({
    List<FacilityEntity>? allFacilities,
    List<FacilityEntity>? filteredFacilities,
    Set<FacilityType>? activeFilters,
    String? searchQuery,
    double? maxDistanceKm,
    bool clearMaxDistance = false,
    double? minRating,
    LatLng? userLocation,
    List<LatLng>? routePoints,
    FacilityEntity? selectedFacility,
    bool clearSelectedFacility = false,
    bool clearRoute = false,
  }) {
    return MapLoaded(
      allFacilities: allFacilities ?? this.allFacilities,
      filteredFacilities: filteredFacilities ?? this.filteredFacilities,
      activeFilters: activeFilters ?? this.activeFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      maxDistanceKm: clearMaxDistance ? null : (maxDistanceKm ?? this.maxDistanceKm),
      minRating: minRating ?? this.minRating,
      userLocation: userLocation ?? this.userLocation,
      routePoints: clearRoute ? [] : (routePoints ?? this.routePoints),
      selectedFacility: clearSelectedFacility
          ? null
          : (selectedFacility ?? this.selectedFacility),
    );
  }

  @override
  List<Object?> get props => [
    allFacilities,
    filteredFacilities,
    activeFilters,
    searchQuery,
    maxDistanceKm,
    minRating,
    userLocation,
    routePoints,
    selectedFacility,
  ];
}

class MapError extends MapState {
  final String message;
  const MapError({required this.message});

  @override
  List<Object?> get props => [message];
}
