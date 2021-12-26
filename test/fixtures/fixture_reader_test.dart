import 'package:flutter_test/flutter_test.dart';

import 'fixture_reader.dart';

void main() {
  test(
    'should return file\'s contents as a string given a valid file name',
    () {
      String fileName = 'fixture_reader_test_file.json';
      final result = fixture(fileName);

      String expectedResult = '{\n'
          '  "theKey": "theValue"\n'
          '}';

      expect(result, expectedResult);
    },
  );

  test(
    'should return an exception when an invalid file name is supplied',
    () {
      String fileName = 'non_existent_file.json';
      expect(() => fixture(fileName), throwsException);
    },
  );
}
