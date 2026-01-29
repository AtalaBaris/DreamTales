import 'package:equatable/equatable.dart';

/// Story - Domain Entity
/// 
/// Clean Architecture'da domain katmanındaki entity'ler:
/// - Veri kaynağından bağımsızdır (API, Firebase, Supabase değişse bile aynı kalır)
/// - Business logic içermez, sadece veri yapısını tanımlar
/// - Equatable ile value equality sağlanır
class Story extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? audioUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Story({
    required this.id,
    required this.title,
    required this.content,
    this.audioUrl,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        audioUrl,
        createdAt,
        updatedAt,
      ];

  /// copyWith - Immutable update için
  /// 
  /// React'taki state update mantığına benzer:
  /// setState({ ...prevState, title: newTitle })
  Story copyWith({
    String? id,
    String? title,
    String? content,
    String? audioUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      audioUrl: audioUrl ?? this.audioUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
