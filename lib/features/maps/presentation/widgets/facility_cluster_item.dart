import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart' as cluster_mgr;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';

/// Presentation-layer wrapper that makes [FacilityEntity] usable by
/// [ClusterManager] without polluting the domain layer with Flutter imports.
class FacilityClusterItem with cluster_mgr.ClusterItem {
  final FacilityEntity facility;

  FacilityClusterItem(this.facility);

  @override
  LatLng get location => LatLng(facility.lat, facility.lng);
}
