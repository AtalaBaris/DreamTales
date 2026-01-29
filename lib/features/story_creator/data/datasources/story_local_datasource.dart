import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story_model.dart';

/// StoryLocalDataSource - Local (cache) veri kaynağı
/// 
/// Clean Architecture'da:
/// - Local storage (SharedPreferences, Hive, SQLite vb.) işlemlerini yapar
/// - Offline çalışma için cache sağlar
/// - Hataları yakalar ve uygun exception'lar fırlatır
abstract class StoryLocalDataSource {
  /// cacheStories - Masalları cache'e kaydeder
  Future<void> cacheStories(List<StoryModel> stories);

  /// getCachedStories - Cache'den masalları getirir
  Future<List<StoryModel>> getCachedStories();

  /// cacheStory - Tek bir masalı cache'e kaydeder
  Future<void> cacheStory(StoryModel story);

  /// getCachedStory - Cache'den tek bir masal getirir
  Future<StoryModel?> getCachedStory(String id);
}

/// StoryLocalDataSourceImpl - StoryLocalDataSource implementasyonu
/// 
/// SharedPreferences kullanarak local storage işlemleri yapar.
/// 
/// TODO: Hive veya SQLite gibi daha güçlü bir çözüm kullanılabilir
class StoryLocalDataSourceImpl implements StoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  // Cache key'leri
  static const String _storiesCacheKey = 'CACHED_STORIES';
  static const String _storyCachePrefix = 'CACHED_STORY_';

  StoryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheStories(List<StoryModel> stories) async {
    try {
      final jsonStories = stories.map((story) => story.toJson()).toList();
      await sharedPreferences.setString(
        _storiesCacheKey,
        jsonEncode(jsonStories),
      );
    } catch (e) {
      throw Exception('Cache kaydetme hatası: $e');
    }
  }

  @override
  Future<List<StoryModel>> getCachedStories() async {
    try {
      final jsonString = sharedPreferences.getString(_storiesCacheKey);
      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => StoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Cache okuma hatası: $e');
    }
  }

  @override
  Future<void> cacheStory(StoryModel story) async {
    try {
      await sharedPreferences.setString(
        '$_storyCachePrefix${story.id}',
        jsonEncode(story.toJson()),
      );
    } catch (e) {
      throw Exception('Cache kaydetme hatası: $e');
    }
  }

  @override
  Future<StoryModel?> getCachedStory(String id) async {
    try {
      final jsonString = sharedPreferences.getString('$_storyCachePrefix$id');
      if (jsonString == null) {
        return null;
      }

      return StoryModel.fromJson(jsonDecode(jsonString));
    } catch (e) {
      throw Exception('Cache okuma hatası: $e');
    }
  }
}
