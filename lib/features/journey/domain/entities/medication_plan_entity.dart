enum PlanStatus { active, completed, failed }

class MedicationPlanEntity {
  final String title;
  final String dateRange;
  final PlanStatus status;
  final String? trackStatus;

  MedicationPlanEntity({
    required this.title,
    required this.dateRange,
    required this.status,
    this.trackStatus,
  });
}