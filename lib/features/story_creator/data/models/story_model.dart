import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/story.dart';

part 'story_model.freezed.dart';
// part 'story_model.g.dart'; // TODO: build_runner çalıştırıldıktan sonra aktif edilecek

/// StoryModel - Data katmanında Story entity'sinin modeli
/// 
/// Clean Architecture'da:
/// - Domain: Story (entity) - veri kaynağından bağımsız
/// - Data: StoryModel - JSON serialization, API response mapping
/// 
/// StoryModel, Story entity'sine dönüştürülebilir (toEntity)
/// ve Story entity'sinden oluşturulabilir (fromEntity).
/// 
/// freezed + json_serializable ile type-safe ve immutable yapı sağlanır.
@freezed
class StoryModel with _$StoryModel {
  const factory StoryModel({
    required String id,
    required String title,
    required String content,
    String? audioUrl,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _StoryModel;

  /// fromJson - JSON'dan StoryModel oluşturur
  /// 
  /// TODO: build_runner çalıştırıldıktan sonra _$StoryModelFromJson kullanılacak
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    // Geçici manuel implementasyon - build_runner çalıştırıldıktan sonra kaldırılacak
    return StoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      audioUrl: json['audioUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
    // Build runner sonrası: return _$StoryModelFromJson(json);
  }
}

/// StoryModelExtension - StoryModel için extension metodlar
/// 
/// Clean Architecture'da data katmanındaki model'ler domain entity'lerine
/// dönüştürülmelidir. Bu sayede domain katmanı data katmanından bağımsız kalır.
extension StoryModelExtension on StoryModel {
  /// toEntity - StoryModel'i Story entity'sine dönüştürür
  Story toEntity() {
    return Story(
      id: id,
      title: title,
      content: content,
      audioUrl: audioUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// toJson - StoryModel'i JSON'a çevirir
  /// 
  /// TODO: build_runner çalıştırıldıktan sonra _$StoryModelToJson kullanılacak
  Map<String, dynamic> toJson() {
    // Geçici manuel implementasyon - build_runner çalıştırıldıktan sonra kaldırılacak
    return {
      'id': id,
      'title': title,
      'content': content,
      'audioUrl': audioUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
    // Build runner sonrası: return _$StoryModelToJson(this);
  }
}

/// StoryEntityExtension - Story entity'sini StoryModel'e dönüştürme extension
extension StoryEntityExtension on Story {
  /// toModel - Story entity'sini StoryModel'e dönüştürür
  StoryModel toModel() {
    return StoryModel(
      id: id,
      title: title,
      content: content,
      audioUrl: audioUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
