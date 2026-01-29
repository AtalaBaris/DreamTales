import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

/// GetAllStories - Tüm masalları getirme use case'i
/// 
/// Parametre gerektirmediği için NoParams kullanır.
class GetAllStories implements UseCase<List<Story>, NoParams> {
  final StoryRepository repository;

  GetAllStories(this.repository);

  @override
  Future<Either<Failure, List<Story>>> call(NoParams params) async {
    return await repository.getAllStories();
  }
}
