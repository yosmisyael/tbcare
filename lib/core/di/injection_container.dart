import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Core ───────────────────────────────────────────────────────────────────────
import 'package:TBConsult/core/network/dio_client.dart';

// ── Health Hub ─────────────────────────────────────────────────────────────────
import 'package:TBConsult/features/health_hub/data/data_sources/conversation_local_data_source.dart';
import 'package:TBConsult/features/health_hub/data/data_sources/triage_remote_data_source.dart';
import 'package:TBConsult/features/health_hub/data/data_sources/tb_knowledge_local_data_source.dart';
import 'package:TBConsult/features/health_hub/data/repositories/conversation_repository_impl.dart';
import 'package:TBConsult/features/health_hub/data/repositories/tb_knowledge_repository_impl.dart';
import 'package:TBConsult/features/health_hub/domain/repositories/conversation_repository.dart';
import 'package:TBConsult/features/health_hub/domain/repositories/tb_knowledge_repository.dart';
import 'package:TBConsult/features/health_hub/domain/usecases/get_conversations_usecase.dart';
import 'package:TBConsult/features/health_hub/domain/usecases/get_conversation_detail_usecase.dart';
import 'package:TBConsult/features/health_hub/domain/usecases/save_conversation_usecase.dart';
import 'package:TBConsult/features/health_hub/domain/usecases/send_message_usecase.dart';
import 'package:TBConsult/features/health_hub/domain/usecases/retrieve_tb_context_usecase.dart';
import 'package:TBConsult/features/health_hub/domain/usecases/generate_summary_usecase.dart';
import 'package:TBConsult/features/health_hub/presentation/cubit/health_hub_cubit.dart';
import 'package:TBConsult/features/health_hub/presentation/cubit/conversation_cubit.dart';

// ── Journey ────────────────────────────────────────────────────────────────────
import 'package:TBConsult/features/journey/data/data_sources/journey_remote_data_source.dart';
import 'package:TBConsult/features/journey/data/repositories/journey_repository_impl.dart';
import 'package:TBConsult/features/journey/domain/repositories/journey_repository.dart';
import 'package:TBConsult/features/journey/domain/usecases/journey_usecases.dart';
import 'package:TBConsult/features/journey/presentation/cubit/journey_cubit.dart';

// ── Medication ─────────────────────────────────────────────────────────────────
import 'package:TBConsult/features/medication/data/data_sources/medication_remote_data_source.dart';
import 'package:TBConsult/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:TBConsult/features/medication/domain/repositories/medication_repository.dart';
import 'package:TBConsult/features/medication/domain/usecases/medication_usecases.dart';
import 'package:TBConsult/features/medication/presentation/cubit/medication_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── External dependencies ──────────────────────────────────────────────
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // ── Network ────────────────────────────────────────────────────────────
  await DioClient.instance.initialize(sharedPrefs);
  sl.registerLazySingleton<DioClient>(() => DioClient.instance);

  // ── Health Hub data sources ────────────────────────────────────────────
  final tbKnowledgeDataSource = TBKnowledgeLocalDataSourceImpl();
  await tbKnowledgeDataSource.initialize();

  sl.registerLazySingleton<TBKnowledgeLocalDataSource>(
        () => tbKnowledgeDataSource,
  );
  sl.registerLazySingleton<ConversationLocalDataSource>(
        () => ConversationLocalDataSourceImpl(prefs: sl()),
  );
  sl.registerLazySingleton<TriageService>(
        () => TriageRemoteDataSource(
      apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
      prefs: sl(),
    ),
  );

  // ── Health Hub repositories ────────────────────────────────────────────
  sl.registerLazySingleton<ConversationRepository>(
        () => ConversationRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<TBKnowledgeRepository>(
        () => TBKnowledgeRepositoryImpl(localDataSource: sl()),
  );

  // ── Health Hub use cases ───────────────────────────────────────────────
  sl.registerLazySingleton(() => GetConversationsUseCase(sl()));
  sl.registerLazySingleton(() => GetConversationDetailUseCase(sl()));
  sl.registerLazySingleton(() => SaveConversationUseCase(sl()));
  sl.registerLazySingleton(() => RetrieveTBContextUseCase(sl()));
  sl.registerLazySingleton(
        () => SendMessageUseCase(
      conversationRepository: sl(),
      knowledgeRepository: sl(),
      triageService: sl<TriageService>(),
    ),
  );
  sl.registerLazySingleton(
        () => GenerateSummaryUseCase(
      conversationRepository: sl(),
      triageService: sl<TriageService>(),
    ),
  );

  // ── Journey data sources ───────────────────────────────────────────────
  sl.registerLazySingleton<JourneyRemoteDataSource>(
        () => JourneyRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // ── Journey repository ─────────────────────────────────────────────────
  sl.registerLazySingleton<JourneyRepository>(
        () => JourneyRepositoryImpl(remoteDataSource: sl()),
  );

  // ── Journey use cases ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => ListJourneysUseCase(sl()));
  sl.registerLazySingleton(() => CreateJourneyUseCase(sl()));
  sl.registerLazySingleton(() => GetJourneyUseCase(sl()));
  sl.registerLazySingleton(() => GetJourneyStatsUseCase(sl()));
  sl.registerLazySingleton(() => ResetJourneyUseCase(sl()));
  sl.registerLazySingleton(() => DeleteJourneyUseCase(sl()));

  // ── Medication data sources ────────────────────────────────────────────
  sl.registerLazySingleton<MedicationRemoteDataSource>(
        () => MedicationRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // ── Medication repository ──────────────────────────────────────────────
  sl.registerLazySingleton<MedicationRepository>(
        () => MedicationRepositoryImpl(remoteDataSource: sl()),
  );

  // ── Medication use cases ───────────────────────────────────────────────
  sl.registerLazySingleton(() => CreateMedicationLogUseCase(sl()));
  sl.registerLazySingleton(() => ListMedicationLogsUseCase(sl()));
  sl.registerLazySingleton(() => ListAchievementsUseCase(sl()));

  // ── Cubits (Factory — new instance per page) ───────────────────────────
  sl.registerFactory(
        () => HealthHubCubit(
      getConversations: sl(),
      conversationRepository: sl(),
    ),
  );
  sl.registerFactory(
        () => ConversationCubit(
      sendMessageUseCase: sl(),
      saveConversationUseCase: sl(),
      getConversationDetailUseCase: sl(),
      generateSummaryUseCase: sl(),
    ),
  );
  sl.registerFactory(
        () => JourneyCubit(
      listJourneysUseCase: sl(),
      createJourneyUseCase: sl(),
      getJourneyUseCase: sl(),
      getJourneyStatsUseCase: sl(),
      resetJourneyUseCase: sl(),
      deleteJourneyUseCase: sl(),
    ),
  );
  sl.registerFactory(
        () => MedicationCubit(
      createLogUseCase: sl(),
      listLogsUseCase: sl(),
      listAchievementsUseCase: sl(),
    ),
  );

}
