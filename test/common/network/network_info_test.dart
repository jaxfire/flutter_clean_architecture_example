import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_arch_learning/common/network/network_info.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

main() {
  late MockDataConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockInternetConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      // Arrange
      Future<bool> expectedFuture = Future.value(true);
      when(() => mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => expectedFuture);

      // Act
      // Note: We don't 'await' the result to keep it a Future
      final returnedFuture = networkInfoImpl.isConnected();

      // Assert
      // We can now referential-equality compare the two Future objects.
      expect(returnedFuture, expectedFuture);
      verify(() => mockInternetConnectionChecker.hasConnection).called(1);
    });
  });
}
