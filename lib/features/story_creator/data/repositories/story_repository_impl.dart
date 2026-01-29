import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_local_datasource.dart';
import '../datasources/story_remote_datasource.dart';
import '../models/story_model.dart'; // Extension'lar için gerekli

/// StoryRepositoryImpl - StoryRepository'nin implementasyonu
/// 
/// Clean Architecture'da repository pattern:
/// - Remote ve local datasource'ları koordine eder
/// - Network durumunu kontrol eder
/// - Hataları Failure'lara dönüştürür
/// - Domain entity'lerine dönüştürür
/// 
/// Bu sayede:
/// - Offline çalışma desteği sağlanır
/// - Cache stratejisi merkezi bir yerde yönetilir
/// - Domain katmanı veri kaynağı detaylarından bağımsız kalır
class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;
  final StoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  StoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Story>> createStory({
    required String title,
    required String content,
  }) async {
    try {
      // Network kontrolü
      if (await networkInfo.isConnected) {
        // Online: Remote datasource kullan
        final storyModel = await remoteDataSource.createStory(
          title: title,
          content: content,
        );

        // Cache'e kaydet
        await localDataSource.cacheStory(storyModel);

        // Domain entity'ye dönüştür ve döndür
        return Right(storyModel.toEntity());
      } else {
        // Offline: Hata döndür
        return const Left(NetworkFailure('İnternet bağlantısı yok'));
      }
    } catch (e) {
      // Hataları Failure'a dönüştür
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> getStory(String id) async {
    try {
      // Önce cache'den kontrol et
      final cachedStory = await localDataSource.getCachedStory(id);
      if (cachedStory != null) {
        return Right(cachedStory.toEntity());
      }

      // Cache'de yoksa ve online ise remote'dan getir
      if (await networkInfo.isConnected) {
        final storyModel = await remoteDataSource.getStory(id);
        await localDataSource.cacheStory(storyModel);
        return Right(storyModel.toEntity());
      } else {
        return const Left(NetworkFailure('İnternet bağlantısı yok'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getAllStories() async {
    try {
      // Önce cache'den getir (hızlı yükleme için)
      final cachedStories = await localDataSource.getCachedStories();
      if (cachedStories.isNotEmpty) {
        // Cache'den döndür ama arka planda remote'dan güncelle
        if (await networkInfo.isConnected) {
          // Arka planda güncelle (fire and forget)
          remoteDataSource.getAllStories().then((remoteStories) {
            localDataSource.cacheStories(remoteStories);
          }).catchError((_) {
            // Hata olursa sessizce devam et
          });
        }
        return Right(
          cachedStories.map<Story>((model) => model.toEntity()).toList(),
        );
      }

      // Cache boşsa ve online ise remote'dan getir
      if (await networkInfo.isConnected) {
        final stories = await remoteDataSource.getAllStories();
        await localDataSource.cacheStories(stories);
        return Right(
          stories.map<Story>((model) => model.toEntity()).toList(),
        );
      } else {
        return const Left(NetworkFailure('İnternet bağlantısı yok'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> updateStory(Story story) async {
    try {
      if (await networkInfo.isConnected) {
        final storyModel = story.toModel();
        final updatedModel = await remoteDataSource.updateStory(storyModel);
        await localDataSource.cacheStory(updatedModel);
        return Right(updatedModel.toEntity());
      } else {
        return const Left(NetworkFailure('İnternet bağlantısı yok'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStory(String id) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteStory(id);
        // TODO: Local cache'den de sil
        return const Right(null);
      } else {
        return const Left(NetworkFailure('İnternet bağlantısı yok'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
