import 'package:flutter/material.dart';

import 'package:TBConsult/features/maps/data/data_sources/facility_photo_service.dart';
import 'package:TBConsult/features/maps/domain/entities/facility_entity.dart';

/// Displays a facility photo fetched lazily from Google Places API.
///
/// Shows a shimmer placeholder while loading, the real photo on success,
/// and a styled gradient fallback on failure — so the sheet always looks
/// polished regardless of network result.
///
/// [photoService] should be injected from the DI container (singleton)
/// so the in-memory cache is shared across all card instances.
class FacilityImageWidget extends StatefulWidget {
  final FacilityEntity facility;
  final FacilityPhotoService photoService;
  final double height;
  final BorderRadius borderRadius;

  const FacilityImageWidget({
    super.key,
    required this.facility,
    required this.photoService,
    this.height = 160,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<FacilityImageWidget> createState() => _FacilityImageWidgetState();
}

class _FacilityImageWidgetState extends State<FacilityImageWidget> {
  late Future<String?> _photoFuture;

  @override
  void initState() {
    super.initState();
    _photoFuture = widget.photoService.fetchPhotoUrl(
      facilityId: widget.facility.id,
      facilityName: widget.facility.name,
      address: widget.facility.address,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: FutureBuilder<String?>(
          future: _photoFuture,
          builder: (context, snapshot) {
            // ── Loading ──────────────────────────────────────────────
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _ShimmerPlaceholder(
                type: widget.facility.type,
              );
            }

            final url = snapshot.data;

            // ── No photo found → styled fallback ─────────────────────
            if (url == null) {
              return _FallbackGradient(type: widget.facility.type);
            }

            // ── Real photo ────────────────────────────────────────────
            return Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: widget.height,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return _ShimmerPlaceholder(type: widget.facility.type);
              },
              errorBuilder: (_, __, ___) =>
                  _FallbackGradient(type: widget.facility.type),
            );
          },
        ),
      ),
    );
  }
}

// ── Shimmer placeholder ───────────────────────────────────────────────────────

class _ShimmerPlaceholder extends StatefulWidget {
  final FacilityType type;
  const _ShimmerPlaceholder({required this.type});

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        color: Colors.grey.shade200.withOpacity(_anim.value + 0.3),
        child: Center(
          child: Icon(
            _typeIcon(widget.type),
            size: 48,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(FacilityType t) {
    switch (t) {
      case FacilityType.hospital:
        return Icons.local_hospital_outlined;
      case FacilityType.clinic:
        return Icons.medical_services_outlined;
      case FacilityType.pharmacy:
        return Icons.local_pharmacy_outlined;
    }
  }
}

// ── Fallback gradient (when no photo available) ───────────────────────────────

class _FallbackGradient extends StatelessWidget {
  final FacilityType type;
  const _FallbackGradient({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(type);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.25), color.withOpacity(0.08)],
        ),
      ),
      child: Center(
        child: Icon(
          _typeIcon(type),
          size: 72,
          color: color.withOpacity(0.35),
        ),
      ),
    );
  }

  IconData _typeIcon(FacilityType t) {
    switch (t) {
      case FacilityType.hospital:
        return Icons.local_hospital_outlined;
      case FacilityType.clinic:
        return Icons.medical_services_outlined;
      case FacilityType.pharmacy:
        return Icons.local_pharmacy_outlined;
    }
  }

  Color _typeColor(FacilityType t) {
    switch (t) {
      case FacilityType.hospital:
        return Colors.blue;
      case FacilityType.clinic:
        return Colors.green;
      case FacilityType.pharmacy:
        return Colors.orange;
    }
  }
}
