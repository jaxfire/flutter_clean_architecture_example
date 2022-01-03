import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_arch_learning/common/error/exception.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/models/number_trivia_model.dart';

class MockSharedPrefs extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPrefs mockSharedPrefs;
  late NumberTriviaLocalDataSourceImpl localDataSource;

  setUp(() {
    mockSharedPrefs = MockSharedPrefs();
    localDataSource = NumberTriviaLocalDataSourceImpl(mockSharedPrefs);
  });

  NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(
    text: 'Test text',
    number: 1,
  );

  group('getNumberTrivia', () {
    test(
      'GIVEN there is a NumberTriviaModel stored in persistence'
      'WHEN getNumberTrivia() is called'
      'THEN the NumberTriviaModel stored in persistence is returned as a Future',
      () async {
        // ARRANGE
        when(() => mockSharedPrefs.getString(
                NumberTriviaLocalDataSourceImpl.numberTriviaPrefsKey))
            .thenReturn(jsonEncode(tNumberTriviaModel).toString());

        // ACT
        NumberTriviaModel result = await localDataSource.getNumberTrivia();
        // ASSERT
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'GIVEN there is not a NumberTriviaModel stored in persistence'
      'WHEN getNumberTrivia() is called'
      'THEN a CacheException should be thrown',
      () {
        // ARRANGE
        when(() => mockSharedPrefs.getString(
                NumberTriviaLocalDataSourceImpl.numberTriviaPrefsKey))
            .thenReturn(null);
        // ACT and ASSERT
        expect(() => localDataSource.getNumberTrivia(),
            throwsA(isA<CacheException>()));
      },
    );

    test(
      'GIVEN the db throws an Exception'
      'WHEN getNumberTrivia() is called'
      'THEN a CacheException should be thrown',
      () {
        // ARRANGE
        when(() => mockSharedPrefs.getString(
                NumberTriviaLocalDataSourceImpl.numberTriviaPrefsKey))
            .thenThrow(Exception());

        // ACT and ASSERT
        expect(() => localDataSource.getNumberTrivia(),
            throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    test(
      'GIVEN a valid NumTriv is passed in'
      'WHEN cacheNumberTrivia() is called'
      'THEN the value should be stored in the db',
      () {
        // ARRANGE
        when(
          () => mockSharedPrefs.setString(
            NumberTriviaLocalDataSourceImpl.numberTriviaPrefsKey,
            jsonEncode(tNumberTriviaModel),
          ),
        ).thenAnswer((_) async => true);

        // ACT
        localDataSource.cacheNumberTrivia(tNumberTriviaModel);

        // ASSERT
        verify(
          () => mockSharedPrefs.setString(
            NumberTriviaLocalDataSourceImpl.numberTriviaPrefsKey,
            jsonEncode(tNumberTriviaModel),
          ),
        ).called(1);
      },
    );
  });
}
