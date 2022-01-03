part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String number;

  GetConcreteNumberTriviaEvent(this.number);

  @override
  List<Object?> get props => [number];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}
