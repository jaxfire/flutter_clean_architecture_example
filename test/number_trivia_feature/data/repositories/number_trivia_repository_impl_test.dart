import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch_learning/common/error/exception.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/common/platform/network_info.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/models/number_trivia_model.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/entities/number_trivia_entity.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class NumberTriviaModelFake extends Fake implements NumberTriviaModel {}

void main() {
  // Object Under Test
  late NumberTriviaRepositoryImpl repo;

  // Required Mocks
  late NumberTriviaLocalDataSource mockLocalDataSource;
  late NumberTriviaRemoteDataSource mockRemoteDataSource;
  late NetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(NumberTriviaModelFake());
  });

  setUp(() {
    // Init mocks and Object Under Test
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repo = NumberTriviaRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTriviaEntity tNumberTrivia =
        tNumberTriviaModel; // Cast from model to entity

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);

      when(() => mockLocalDataSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);

      // act
      await repo.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => mockNetworkInfo.isConnected()).called(1);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async {});

        // act
        final result = await repo.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, equals(Right(tNumberTrivia)));
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .called(1);
      });

      test('should cache the trivia on successful network response', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer(
                (_) async {}); // Note: This is how to return a Future<void>.

        // act
        await repo.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
      });

      test('should return ServerFailure when ServerException occurs', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        // act
        final result = await repo.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repo.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, equals(Right(tNumberTrivia)));
        verifyNever(
            () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await repo.getConcreteNumberTrivia(tNumber);

        expect(result, Left(CacheFailure()));

        // assert
        verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(any()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTriviaEntity tNumberTrivia =
        tNumberTriviaModel; // Cast from model to entity

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      when(() => mockLocalDataSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);

      // act
      await repo.getRandomNumberTrivia();

      // assert
      verify(() => mockNetworkInfo.isConnected()).called(1);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async {});

        // act
        final result = await repo.getRandomNumberTrivia();

        // assert
        expect(result, equals(Right(tNumberTrivia)));
        verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
      });

      test('should cache the trivia on successful network response', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer(
                (_) async {}); // Note: This is how to return a Future<void>.

        // act
        await repo.getRandomNumberTrivia();

        // assert
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
      });

      test('should return ServerFailure when ServerException occurs', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        // act
        final result = await repo.getRandomNumberTrivia();

        // assert
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repo.getRandomNumberTrivia();

        // assert
        expect(result, equals(Right(tNumberTrivia)));
        verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await repo.getRandomNumberTrivia();

        expect(result, Left(CacheFailure()));

        // assert
        verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
      });
    });
  });
}
