import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/entities/number_trivia_entity.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTriviaUseCase useCase;
  late NumberTriviaRepository mockRepo;

  setUp(() {
    mockRepo = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTriviaUseCase(mockRepo);
  });

  test(
    'should get trivia for the number from the repository',
    () async {
      final testNumberTrivia = NumberTriviaEntity(number: 1, text: 'test');

      when(() => mockRepo.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Right(testNumberTrivia));

      Either<Failure, NumberTriviaEntity> result = await useCase(Params(1));

      expect(result, Right(testNumberTrivia));

      verify(() => mockRepo.getConcreteNumberTrivia(any())).called(1);
    },
  );
}
