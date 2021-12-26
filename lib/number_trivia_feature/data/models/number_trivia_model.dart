import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/entities/number_trivia_entity.dart';

// TODO: Consider using json_serializable package to generate toJson and fromJson.
class NumberTriviaModel extends NumberTriviaEntity {
  NumberTriviaModel({required String text, required int number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap) {
    return NumberTriviaModel(
      text: jsonMap['text'],
      number: (jsonMap['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'number': number};

  @override
  List<Object> get props => [text, number];
}
