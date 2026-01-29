import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/story_creator/data/datasources/story_local_datasource.dart';
import '../../features/story_creator/data/datasources/story_remote_datasource.dart';
import '../../features/story_creator/data/repositories/story_repository_impl.dart';
import '../../features/story_creator/domain/repositories/story_repository.dart';
import '../../features/story_creator/domain/usecases/create_story.dart';
import '../../features/story_creator/domain/usecases/get_all_stories.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/audio_player/data/services/flutter_tts_service_impl.dart';
import '../../features/audio_player/domain/services/text_to_speech_service.dart';
import '../network/network_info.dart';

/// GetIt - Dependency Injection container
/// 
/// Clean Architecture'da DI:
/// - Concrete sınıflar merkezi bir yerde üretilir
/// - Testlerde mock'lamak kolay olur
/// - Bağımlılıklar açıkça tanımlanır
/// 
/// Injectable paketi ile code generation yapılabilir,
/// şimdilik manuel setup yapıyoruz.
final getIt = GetIt.instance;

/// setupInjection - Dependency Injection setup
/// 
/// Uygulama başlangıcında (main.dart) çağrılmalıdır.
Future<void> setupInjection() async {
  // External dependencies (SharedPreferences, Dio vb.)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.dreamtales.com', // TODO: Environment'a göre ayarla
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  getIt.registerLazySingleton<Dio>(() => dio);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );

  // Data sources
  getIt.registerLazySingleton<StoryRemoteDataSource>(
    () => StoryRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<StoryLocalDataSource>(
    () => StoryLocalDataSourceImpl(
      sharedPreferences: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<StoryRepository>(
    () => StoryRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => CreateStory(getIt()),
  );

  getIt.registerLazySingleton(
    () => GetAllStories(getIt()),
  );

  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // Text-to-Speech Service
  getIt.registerLazySingleton<TextToSpeechService>(
    () => FlutterTtsServiceImpl(),
  );
}
