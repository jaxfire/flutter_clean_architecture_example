import 'package:dartz/dartz.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/feature/domain/entities/number_trivia.dart';
import 'package:tdd_clean_arch_learning/feature/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase {
  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
