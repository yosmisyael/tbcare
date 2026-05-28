import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:TBConsult/core/usecases/usecase.dart';
import 'package:TBConsult/features/medication/domain/usecases/medication_usecases.dart';
import 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final CreateMedicationLogUseCase createLogUseCase;
  final ListMedicationLogsUseCase listLogsUseCase;
  final ListAchievementsUseCase listAchievementsUseCase;

  MedicationCubit({
    required this.createLogUseCase,
    required this.listLogsUseCase,
    required this.listAchievementsUseCase,
  }) : super(const MedicationInitial());

  Future<void> loadLogs({String? journeyId, int limit = 20, int offset = 0}) async {
    emit(const MedicationLoading());
    try {
      final result = await listLogsUseCase(
        ListLogsParams(journeyId: journeyId, limit: limit, offset: offset),
      );
      emit(MedicationLogsLoaded(logs: result.logs, total: result.total));
    } catch (e) {
      emit(MedicationError(message: e.toString()));
    }
  }

  Future<void> submitLog({
    required String journeyId,
    required DateTime timeTaken,
    required List<Map<String, dynamic>> entries,
    String? notes,
  }) async {
    emit(const MedicationLoading());
    try {
      final log = await createLogUseCase(
        CreateLogParams(
          journeyId: journeyId,
          timeTaken: timeTaken,
          entries: entries,
          notes: notes,
        ),
      );
      emit(MedicationLogSubmitted(log: log));
    } catch (e) {
      emit(MedicationError(message: e.toString()));
    }
  }

  Future<void> loadAchievements() async {
    emit(const MedicationLoading());
    try {
      final result = await listAchievementsUseCase(const NoParams());
      emit(AchievementsLoaded(
        achievements: result.achievements,
        totalUnlocked: result.totalUnlocked,
        total: result.total,
      ));
    } catch (e) {
      emit(MedicationError(message: e.toString()));
    }
  }
}
