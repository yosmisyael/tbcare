import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';

class FacilityDetailSheet extends StatelessWidget {
  final FacilityEntity facility;

  const FacilityDetailSheet({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ────────────────────────────────────────────
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Facility image placeholder ─────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _typeColor(facility.type).withOpacity(0.3),
                            _typeColor(facility.type).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        _typeIcon(facility.type),
                        size: 72,
                        color: _typeColor(facility.type).withOpacity(0.4),
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            facility.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── DOTS badge + distance ────────────────────────────
                  Row(
                    children: [
                      if (facility.isDotsCertified) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'DOTS CERTIFIED',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                      if (facility.distanceKm != null) ...[
                        if (!facility.isDotsCertified) const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              facility.distanceKm! < 1
                                  ? '${(facility.distanceKm! * 1000).round()} m'
                                  : '${facility.distanceKm!.toStringAsFixed(1)} km',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Name ─────────────────────────────────────────────
                  Text(
                    facility.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ── Address ──────────────────────────────────────────
                  Text(
                    facility.address,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),

                  const SizedBox(height: 14),

                  // ── Info cards ───────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.access_time_rounded,
                          label: 'Jam Operasional',
                          value: facility.operationalHours,
                        ),
                      ),
                      if (facility.tbcUnit != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.medical_services_outlined,
                            label: 'Unit TBC',
                            value: facility.tbcUnit!,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Services chips ───────────────────────────────────
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: facility.services
                        .map(
                          (s) => Chip(
                            label: Text(
                              s,
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor: Colors.grey[100],
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // ── Navigate Here ─────────────────────────────────────
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => _openGoogleMaps(facility.lat, facility.lng),
                    icon: const Icon(
                      Icons.navigation_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Navigate Here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Contact Facility ──────────────────────────────────
                  TextButton.icon(
                    onPressed: facility.phone != null
                        ? () => _call(facility.phone!)
                        : null,
                    icon: Icon(
                      Icons.phone_outlined,
                      color: facility.phone != null
                          ? AppColors.primary
                          : Colors.grey[400],
                    ),
                    label: Text(
                      'Contact Facility',
                      style: TextStyle(
                        color: facility.phone != null
                            ? AppColors.primary
                            : Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _call(String phone) async {
    // Clean phone number: remove '-', ' ', and keep digits and leading '+'
    final cleanedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanedPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback if unable to launch
      await launchUrl(uri);
    }
  }

  IconData _typeIcon(FacilityType type) {
    switch (type) {
      case FacilityType.hospital:
        return Icons.local_hospital_outlined;
      case FacilityType.clinic:
        return Icons.medical_services_outlined;
      case FacilityType.pharmacy:
        return Icons.local_pharmacy_outlined;
    }
  }

  Color _typeColor(FacilityType type) {
    switch (type) {
      case FacilityType.hospital:
        return Colors.blue;
      case FacilityType.clinic:
        return Colors.green;
      case FacilityType.pharmacy:
        return Colors.orange;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
