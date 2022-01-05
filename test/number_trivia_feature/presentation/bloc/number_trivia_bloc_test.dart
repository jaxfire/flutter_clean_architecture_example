import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/common/use_case/use_case.dart';
import 'package:tdd_clean_arch_learning/common/util/type_converter.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/entities/number_trivia_entity.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTriviaUseCase extends Mock
    implements GetConcreteNumberTriviaUseCase {}

class MockGetRandomNumberTriviaUseCase extends Mock
    implements GetRandomNumberTriviaUseCase {}

class MockTypeConverter extends Mock implements TypeConverter {}

void main() {
  late MockGetConcreteNumberTriviaUseCase _mockGetConcreteNumberTriviaUseCase;
  late MockGetRandomNumberTriviaUseCase _mockGetRandomNumberTriviaUseCase;
  late MockTypeConverter _mockTypeConverter;
  late NumberTriviaBloc _bloc;

  setUp(() {
    _mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    _mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    _mockTypeConverter = MockTypeConverter();

    _bloc = NumberTriviaBloc(
      getConcreteNumberTriviaUseCase: _mockGetConcreteNumberTriviaUseCase,
      getRandomNumberTriviaUseCase: _mockGetRandomNumberTriviaUseCase,
      typeConverter: _mockTypeConverter,
    );
  });

  final tNumberTrivia = NumberTriviaEntity(text: 'Test text', number: 1);

  test(
    'WHEN the bloc is initialised'
    'THEN the initial state should be Empty',
    () async {
      // ASSERT
      await expectLater(_bloc.state, Empty());
    },
  );

  group('getConcreteNumberTrivia', () {
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'calls the type converter',
      setUp: () {
        when(() => _mockTypeConverter.toUnsignedInteger(any()))
            .thenReturn(Right(1));
        when(() => _mockGetConcreteNumberTriviaUseCase.call(Params(1)))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => _bloc,
      act: (bloc) => _bloc.add(GetConcreteNumberTriviaEvent("1")),
      verify: (_) {
        verify(() => _mockTypeConverter.toUnsignedInteger("1"));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'calls usecase',
      setUp: () {
        when(() => _mockTypeConverter.toUnsignedInteger(any()))
            .thenReturn(Right(1));
        when(() => _mockGetConcreteNumberTriviaUseCase.call(Params(1)))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => _bloc,
      act: (bloc) => _bloc.add(GetConcreteNumberTriviaEvent("1")),
      verify: (_) {
        verify(() => _mockGetConcreteNumberTriviaUseCase.call(Params(1)));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Yields Loading then Loaded with correct data',
      setUp: () {
        when(() => _mockTypeConverter.toUnsignedInteger(any()))
            .thenReturn(Right(1));
        when(() => _mockGetConcreteNumberTriviaUseCase.call(Params(1)))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => _bloc,
      act: (bloc) => bloc.add(GetConcreteNumberTriviaEvent('1')),
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Yields Loading then Error when bad input is supplied',
      setUp: () {
        when(() => _mockTypeConverter.toUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
      },
      build: () => _bloc,
      act: (bloc) => bloc.add(GetConcreteNumberTriviaEvent('-4')),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Yields Loading then Error when a ServerFailure occurs.',
      setUp: () {
        when(() => _mockTypeConverter.toUnsignedInteger(any()))
            .thenReturn(Right(1));
        when(() => _mockGetConcreteNumberTriviaUseCase.call(Params(1)))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => _bloc,
      act: (bloc) => bloc.add(GetConcreteNumberTriviaEvent('1')),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Yields Loading then Error when a CacheFailure occurs.',
      setUp: () {
        when(() => _mockTypeConverter.toUnsignedInteger(any()))
            .thenReturn(Right(1));
        when(() => _mockGetConcreteNumberTriviaUseCase.call(Params(1)))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => _bloc,
      act: (bloc) => bloc.add(GetConcreteNumberTriviaEvent('1')),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('getRandomNumberTrivia', () {
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'calls usecase',
      setUp: () {
        when(() => _mockGetRandomNumberTriviaUseCase.call(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => _bloc,
      act: (bloc) => _bloc.add(GetRandomNumberTriviaEvent()),
      verify: (_) {
        verify(() => _mockGetRandomNumberTriviaUseCase.call(NoParams()));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Yields Loading then Loaded with correct data',
      setUp: () {
        when(() => _mockGetRandomNumberTriviaUseCase.call(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => _bloc,
      act: (bloc) => bloc.add(GetRandomNumberTriviaEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Yields Loading then Error when a ServerFailure occurs.',
      setUp: () {
        when(() => _mockGetRandomNumberTriviaUseCase.call(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => _bloc,
      act: (bloc) => bloc.add(GetRandomNumberTriviaEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'Yields Loading then Error when a CacheFailure occurs.',
      setUp: () {
        when(() => _mockGetRandomNumberTriviaUseCase.call(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => _bloc,
      act: (bloc) => bloc.add(GetRandomNumberTriviaEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
