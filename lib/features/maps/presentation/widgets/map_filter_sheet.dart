import 'package:flutter/material.dart';

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';

class MapFilterSheet extends StatefulWidget {
  final Set<FacilityType> initialFilters;
  final ValueChanged<Set<FacilityType>> onApply;

  const MapFilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<MapFilterSheet> createState() => _MapFilterSheetState();
}

class _MapFilterSheetState extends State<MapFilterSheet> {
  late Set<FacilityType> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 16),

          // ── Header ─────────────────────────────────────────────────
          Row(
            children: [
              const Text(
                'Map Layers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Filter options ──────────────────────────────────────────
          _FilterTile(
            type: FacilityType.hospital,
            icon: Icons.local_hospital_outlined,
            iconColor: Colors.blue,
            iconBg: Colors.blue.shade50,
            title: 'Health Facilities (DOTS)',
            subtitle: 'View authorized treatment centers',
            isSelected:
                _selected.isEmpty || _selected.contains(FacilityType.hospital),
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
                _selected.isEmpty || _selected.contains(FacilityType.pharmacy),
            onChanged: (v) => _toggle(FacilityType.pharmacy, v),
          ),

          const SizedBox(height: 24),

          // ── Apply ───────────────────────────────────────────────────
          ElevatedButton(
            onPressed: () {
              widget.onApply(_selected);
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
              'Apply Layers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
