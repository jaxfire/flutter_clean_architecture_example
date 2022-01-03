import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_arch_learning/common/util/type_converter.dart';

void main() {
  late TypeConverter _typeConverter;

  setUp(() {
    _typeConverter = TypeConverter();
  });

  group(
    'toUnsignedInteger',
    () {
      test(
        'GIVEN that the input string represents a positive integer value, including zero'
        'WHEN the method is called'
        'THEN the Integer representation of the String is returned',
        () {
          final testPairs = [
            {'1': 1},
            {'3': 3},
            {'5000': 5000},
            {'1000000': 1000000},
            {'999999999999': 999999999999},
          ];

          testPairs.forEach((testPair) {
            // ACT
            final result =
                _typeConverter.toUnsignedInteger(testPair.keys.first);
            // ASSERT
            expect(result, Right(testPair.values.first));
          });
        },
      );

      test(
        'GIVEN that the input string represents a negative integer value'
        'WHEN the method is called'
        'THEN an InvalidInputFailure is returned',
        () {
          final inputValues = {
            '-1',
            '-3',
            '-5000',
            '-1000000',
            '-999999999999'
          };
          inputValues.forEach((inputValue) {
            // ACT
            final result = _typeConverter.toUnsignedInteger(inputValue);
            // ASSERT
            expect(result, Left(InvalidInputFailure()));
          });
        },
      );

      test(
        'GIVEN that the input string does not represent an integer value'
        'WHEN the method is called'
        'THEN an InvalidInputFailure is returned',
        () {
          final inputValues = {'a', '1t', '-5000h', '!', '2!'};
          inputValues.forEach((inputValue) {
            // ACT
            final result = _typeConverter.toUnsignedInteger(inputValue);
            // ASSERT
            expect(result, Left(InvalidInputFailure()));
          });
        },
      );
    },
  );
}
