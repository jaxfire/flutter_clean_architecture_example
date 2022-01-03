import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch_learning/common/error/exception.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/models/number_trivia_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FallbackValueUri extends Fake implements Uri {}

late NumberTriviaRemoteDataSourceImpl _remoteDataSource;
late MockHttpClient _mockHttpClient;

void _setupHttpClientResponse({required bool successful}) {
  when(
    () => _mockHttpClient.get(
      any(),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer(
    (_) async => http.Response(
      successful ? fixture('trivia.json') : '',
      successful ? 200 : 404,
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(FallbackValueUri());
  });

  setUp(() {
    _mockHttpClient = MockHttpClient();
    _remoteDataSource =
        NumberTriviaRemoteDataSourceImpl(client: _mockHttpClient);
  });

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;

      test(
        'GIVEN a number is provided'
        'WHEN a request is made'
        'THEN a get request is made with the supplied number and the application/json header is set',
        () {
          // ARRANGE
          // Stub so that the mock does not return null.
          _setupHttpClientResponse(successful: true);
          // ACT
          _remoteDataSource.getConcreteNumberTrivia(tNumber);
          // ASSERT
          verify(
            () => _mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ),
          );
        },
      );

      test(
        'WHEN a HTTP 200 response is received'
        'THEN the returned model should contain the same data as the JSON response.',
        () async {
          // ARRANGE
          _setupHttpClientResponse(successful: true);
          // ACT
          final result =
              await _remoteDataSource.getConcreteNumberTrivia(tNumber);

          // ASSERT
          expect(
              result, equals(NumberTriviaModel(text: 'Test text', number: 1)));
        },
      );

      test(
        'GIVEN '
        'WHEN a non-200 response is received'
        'THEN a ServerException should be thrown',
        () async {
          // ARRANGE
          _setupHttpClientResponse(successful: false);
          // ACT and ASSERT
          expect(
            () => _remoteDataSource.getConcreteNumberTrivia(tNumber),
            throwsA(
              isA<ServerException>(),
            ),
          );
        },
      );
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final tNumber = 1;

      test(
        'WHEN getRandomNumberTrivia is called'
        'THEN a get request to the correct url is made with the application/json header set',
        () {
          // ARRANGE
          // Stub so that the mock does not return null.
          _setupHttpClientResponse(successful: true);
          // ACT
          _remoteDataSource.getRandomNumberTrivia();
          // ASSERT
          verify(
            () => _mockHttpClient.get(
              Uri.parse('http://numbersapi.com/random'),
              headers: {'Content-Type': 'application/json'},
            ),
          );
        },
      );

      test(
        'WHEN a HTTP 200 response is received'
        'THEN the returned model should contain the same data as the JSON response.',
        () async {
          // ARRANGE
          _setupHttpClientResponse(successful: true);
          // ACT
          final result = await _remoteDataSource.getRandomNumberTrivia();

          // ASSERT
          expect(
              result, equals(NumberTriviaModel(text: 'Test text', number: 1)));
        },
      );

      test(
        'GIVEN '
        'WHEN a non-200 response is received'
        'THEN a ServerException should be thrown',
        () async {
          // ARRANGE
          _setupHttpClientResponse(successful: false);
          // ACT and ASSERT
          expect(
            () => _remoteDataSource.getRandomNumberTrivia(),
            throwsA(
              isA<ServerException>(),
            ),
          );
        },
      );
    },
  );
}
