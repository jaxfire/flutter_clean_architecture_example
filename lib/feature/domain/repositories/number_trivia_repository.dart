import 'package:dartz/dartz.dart' show Either;
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/feature/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
