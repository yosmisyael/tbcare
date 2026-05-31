import 'package:equatable/equatable.dart';

enum FacilityType { hospital, clinic, pharmacy }

extension FacilityTypeX on FacilityType {
  String get label {
    switch (this) {
      case FacilityType.hospital:
        return 'Rumah Sakit';
      case FacilityType.clinic:
        return 'Klinik & Puskesmas';
      case FacilityType.pharmacy:
        return 'Apotek';
    }
  }

  String get filterLabel {
    switch (this) {
      case FacilityType.hospital:
        return 'Hospitals';
      case FacilityType.clinic:
        return 'Clinics';
      case FacilityType.pharmacy:
        return 'Pharmacies';
    }
  }
}

class FacilityEntity extends Equatable {
  final String id;
  final String name;
  final FacilityType type;
  final String address;
  final double lat;
  final double lng;
  final String? phone;
  final String operationalHours;
  final bool isDotsCertified;
  final String? tbcUnit;
  final double rating;
  final List<String> services;

  /// Populated at runtime after distance calculation.
  final double? distanceKm;

  /// Populated at runtime by [FacilityPhotoService].
  /// Either a full https:// URL or null (shows fallback gradient).
  final String? photoUrl;

  const FacilityEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.lat,
    required this.lng,
    required this.operationalHours,
    required this.isDotsCertified,
    required this.rating,
    required this.services,
    this.phone,
    this.tbcUnit,
    this.distanceKm,
    this.photoUrl,
  });

  FacilityEntity copyWith({
    double? distanceKm,
    String? photoUrl,
  }) =>
      FacilityEntity(
        id: id,
        name: name,
        type: type,
        address: address,
        lat: lat,
        lng: lng,
        phone: phone,
        operationalHours: operationalHours,
        isDotsCertified: isDotsCertified,
        tbcUnit: tbcUnit,
        rating: rating,
        services: services,
        distanceKm: distanceKm ?? this.distanceKm,
        photoUrl: photoUrl ?? this.photoUrl,
      );

  @override
  List<Object?> get props => [
    id, name, type, address, lat, lng, phone, operationalHours,
    isDotsCertified, tbcUnit, rating, services, distanceKm, photoUrl,
  ];
}
