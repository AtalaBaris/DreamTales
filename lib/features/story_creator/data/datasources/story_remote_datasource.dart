import 'package:dio/dio.dart';
import '../models/story_model.dart';

/// StoryRemoteDataSource - Remote (API) veri kaynağı
/// 
/// Clean Architecture'da data katmanı:
/// - API çağrılarını yapar
/// - JSON response'ları parse eder
/// - Hataları yakalar ve uygun exception'lar fırlatır
/// 
/// Bu interface, repository'nin veri kaynağından bağımsız olmasını sağlar.
/// API değişse bile (REST -> GraphQL) sadece bu sınıf değişir.
abstract class StoryRemoteDataSource {
  /// createStory - API'ye masal oluşturma isteği gönderir
  Future<StoryModel> createStory({
    required String title,
    required String content,
  });

  /// getStory - API'den masal getirir
  Future<StoryModel> getStory(String id);

  /// getAllStories - API'den tüm masalları getirir
  Future<List<StoryModel>> getAllStories();

  /// updateStory - API'ye masal güncelleme isteği gönderir
  Future<StoryModel> updateStory(StoryModel story);

  /// deleteStory - API'ye masal silme isteği gönderir
  Future<void> deleteStory(String id);
}

/// StoryRemoteDataSourceImpl - StoryRemoteDataSource implementasyonu
/// 
/// Dio HTTP client kullanarak API çağrıları yapar.
/// 
/// TODO: Base URL ve endpoint'ler environment'a göre ayarlanacak
class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final Dio dio;

  StoryRemoteDataSourceImpl({required this.dio});

  // Base URL - TODO: Environment'a göre ayarlanacak
  static const String _baseUrl = 'https://api.dreamtales.com';
  static const String _storiesEndpoint = '/stories';

  @override
  Future<StoryModel> createStory({
    required String title,
    required String content,
  }) async {
    try {
      final response = await dio.post(
        '$_baseUrl$_storiesEndpoint',
        data: {
          'title': title,
          'content': content,
        },
      );

      return StoryModel.fromJson(response.data);
    } on DioException catch (e) {
      // Dio hatalarını yakala ve uygun exception fırlat
      throw _handleDioError(e);
    }
  }

  @override
  Future<StoryModel> getStory(String id) async {
    try {
      final response = await dio.get('$_baseUrl$_storiesEndpoint/$id');
      return StoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<StoryModel>> getAllStories() async {
    try {
      final response = await dio.get('$_baseUrl$_storiesEndpoint');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => StoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<StoryModel> updateStory(StoryModel story) async {
    try {
      final response = await dio.put(
        '$_baseUrl$_storiesEndpoint/${story.id}',
        data: story.toJson(),
      );
      return StoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteStory(String id) async {
    try {
      await dio.delete('$_baseUrl$_storiesEndpoint/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// _handleDioError - Dio hatalarını işler
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Bağlantı zaman aşımına uğradı');
      case DioExceptionType.badResponse:
        return Exception('Sunucu hatası: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('İstek iptal edildi');
      default:
        return Exception('Bilinmeyen bir hata oluştu');
    }
  }
}
