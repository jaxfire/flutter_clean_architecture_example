import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/common/use_case/use_case.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/entities/number_trivia_entity.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  group('MyTests', () {
    late GetRandomNumberTriviaUseCase useCase;
    late NumberTriviaRepository mockRepo;

    setUp(() {
      mockRepo = MockNumberTriviaRepository();
      useCase = GetRandomNumberTriviaUseCase(mockRepo);
    });

    test(
      'should get trivia from the repository',
      () async {
        final testNumberTrivia =
            NumberTriviaEntity(number: 4, text: 'Some trivia');

        when(() => mockRepo.getRandomNumberTrivia())
            .thenAnswer((_) async => Right(testNumberTrivia));

        Either<Failure, NumberTriviaEntity> result = await useCase(NoParams());

        expect(result, Right(testNumberTrivia));

        verify(() => mockRepo.getRandomNumberTrivia()).called(1);

        // TODO: Mocktail. How to check for no other interactions?
      },
    );
  });
}
