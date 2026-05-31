import 'package:flutter/material.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';

class MapFilterSheet extends StatefulWidget {
  final Set<FacilityType> initialFilters;
  final double? initialMaxDistance;
  final double initialMinRating;
  final void Function(
    Set<FacilityType> types,
    double? maxDistance,
    double minRating,
  )
  onApply;

  const MapFilterSheet({
    super.key,
    required this.initialFilters,
    this.initialMaxDistance,
    required this.initialMinRating,
    required this.onApply,
  });

  @override
  State<MapFilterSheet> createState() => _MapFilterSheetState();
}

class _MapFilterSheetState extends State<MapFilterSheet> {
  late Set<FacilityType> _selected;
  double? _maxDistance;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialFilters);
    _maxDistance = widget.initialMaxDistance;
    _minRating = widget.initialMinRating;
  }

  void _reset() {
    setState(() {
      _selected.clear();
      _maxDistance = null;
      _minRating = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.68,
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ─────────────────────────────────────────────────
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
            const SizedBox(height: 12),

            // ── Header ─────────────────────────────────────────────────
            Row(
              children: [
                const Text(
                  'Filter Places',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _reset,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Text(
              'Show places by distance, rating, and facility type.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 18),

            // ── Distance Slider ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Max Distance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  _maxDistance == null
                      ? 'Any'
                      : '${_maxDistance!.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Slider(
              value: _maxDistance ?? 50.0,
              min: 1,
              max: 50,
              divisions: 49,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryLight.withValues(alpha: 0.3),
              onChanged: (value) {
                setState(() {
                  _maxDistance = value;
                });
              },
            ),
            if (_maxDistance != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _maxDistance = null),
                  child: const Text('Clear distance limit'),
                ),
              )
            else
              const SizedBox(height: 16),

            // ── Rating Slider ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minimum Rating',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.accentYellow,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _minRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Slider(
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 10,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryLight.withValues(alpha: 0.3),
              onChanged: (value) {
                setState(() {
                  _minRating = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // ── Layer options ──────────────────────────────────────────
            const Text(
              'Facility Types',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _FilterTile(
              type: FacilityType.hospital,
              icon: Icons.local_hospital_outlined,
              iconColor: Colors.blue,
              iconBg: Colors.blue.shade50,
              title: 'Health Facilities (DOTS)',
              subtitle: 'View authorized treatment centers',
              isSelected:
                  _selected.isEmpty ||
                  _selected.contains(FacilityType.hospital),
              onChanged: (v) => _toggle(FacilityType.hospital, v),
            ),
            const SizedBox(height: 8),
            _FilterTile(
              type: FacilityType.clinic,
              icon: Icons.medical_services_outlined,
              iconColor: Colors.green,
              iconBg: Colors.green.shade50,
              title: 'Clinics & Puskesmas',
              subtitle: 'Community health centers',
              isSelected:
                  _selected.isEmpty || _selected.contains(FacilityType.clinic),
              onChanged: (v) => _toggle(FacilityType.clinic, v),
            ),
            const SizedBox(height: 8),
            _FilterTile(
              type: FacilityType.pharmacy,
              icon: Icons.local_pharmacy_outlined,
              iconColor: Colors.orange,
              iconBg: Colors.orange.shade50,
              title: 'Pharmacies',
              subtitle: 'Medication & prescription services',
              isSelected:
                  _selected.isEmpty ||
                  _selected.contains(FacilityType.pharmacy),
              onChanged: (v) => _toggle(FacilityType.pharmacy, v),
            ),

            const SizedBox(height: 20),

            // ── Apply ───────────────────────────────────────────────────
            ElevatedButton(
              onPressed: () {
                widget.onApply(_selected, _maxDistance, _minRating);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggle(FacilityType type, bool selected) {
    setState(() {
      if (selected) {
        _selected.add(type);
        // If all are selected, reset to empty (= all)
        if (_selected.length == FacilityType.values.length) {
          _selected = {};
        }
      } else {
        _selected.remove(type);
        // If none are selected, select all
        if (_selected.isEmpty) {
          _selected = Set.from(FacilityType.values);
          _selected.remove(type);
        }
      }
    });
  }
}

class _FilterTile extends StatelessWidget {
  final FacilityType type;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const _FilterTile({
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Checkbox(
            value: isSelected,
            activeColor: AppColors.primary,
            shape: const CircleBorder(),
            onChanged: (v) => onChanged(v ?? false),
          ),
        ],
      ),
    );
  }
}
