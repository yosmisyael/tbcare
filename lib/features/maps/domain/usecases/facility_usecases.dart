import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:TBConsult/core/usecases/usecase.dart';
import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';
import 'package:TBConsult/features/maps/domain/repositories/facility_repository.dart';

// ─── Get Facilities ───────────────────────────────────────────────────────────

class GetFacilitiesParams extends Equatable {
  final LatLng? userLocation;

  const GetFacilitiesParams({this.userLocation});

  @override
  List<Object?> get props => [userLocation];
}

class GetFacilitiesUseCase
    implements UseCase<List<FacilityEntity>, GetFacilitiesParams> {
  final FacilityRepository repository;

  const GetFacilitiesUseCase(this.repository);

  @override
  Future<List<FacilityEntity>> call(GetFacilitiesParams params) =>
      repository.getFacilities(userLocation: params.userLocation);
}

// ─── Get Route ────────────────────────────────────────────────────────────────

class GetRouteParams extends Equatable {
  final LatLng origin;
  final LatLng destination;

  const GetRouteParams({required this.origin, required this.destination});

  @override
  List<Object?> get props => [origin, destination];
}

class GetRouteUseCase implements UseCase<List<LatLng>, GetRouteParams> {
  final FacilityRepository repository;

  const GetRouteUseCase(this.repository);

  @override
  Future<List<LatLng>> call(GetRouteParams params) => repository.getRoute(
    origin: params.origin,
    destination: params.destination,
  );
}
