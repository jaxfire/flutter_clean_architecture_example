import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_arch_learning/common/error/exception.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  static const numberTriviaPrefsKey = 'numberTriviaPrefsKey';

  final SharedPreferences _prefs;

  NumberTriviaLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) async {
    try {
      _prefs.setString(
          numberTriviaPrefsKey, jsonEncode(numberTriviaModel.toJson()));
    } on Exception {
      return;
    }
  }

  @override
  Future<NumberTriviaModel> getNumberTrivia() async {
    final SharedPreferences prefs = await _prefs;
    try {
      String? jsonString = prefs.getString(numberTriviaPrefsKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return NumberTriviaModel.fromJson(json);
      } else {
        throw CacheException();
      }
    } on Exception {
      throw CacheException();
    }
  }
}
