import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/feature/domain/entities/number_trivia.dart';
import 'package:tdd_clean_arch_learning/feature/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_clean_arch_learning/feature/domain/use_cases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  group('MyTests', () {
    late GetConcreteNumberTriviaUseCase useCase;
    late NumberTriviaRepository mockRepo;

    setUp(() {
      mockRepo = MockNumberTriviaRepository();
      useCase = GetConcreteNumberTriviaUseCase(mockRepo);
    });

    test(
      'should get trivia for the number from the repository',
      () async {
        final testNumberTrivia = NumberTrivia(number: 1, text: 'test');

        when(() => mockRepo.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Right(testNumberTrivia));

        Either<Failure, NumberTrivia> result = await useCase.execute(number: 1);

        expect(result, Right(testNumberTrivia));

        verify(() => mockRepo.getConcreteNumberTrivia(any())).called(1);
      },
    );
  });
}
