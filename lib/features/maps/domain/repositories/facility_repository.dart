import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entities/facility_entity.dart';

abstract class FacilityRepository {
  /// Returns all facilities, with [distanceKm] populated if [userLocation] given.
  Future<List<FacilityEntity>> getFacilities({LatLng? userLocation});

  /// Fetch a road-accurate polyline from [origin] to [destination]
  /// using the Google Directions API.
  Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
  });
}
