import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';
import 'package:tdd_clean_arch_learning/common/use_case/use_case.dart';
import 'package:tdd_clean_arch_learning/common/util/type_converter.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/entities/number_trivia_entity.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase _getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase _getRandomNumberTriviaUseCase;
  final TypeConverter _typeConverter;

  NumberTriviaBloc(
    this._getConcreteNumberTriviaUseCase,
    this._getRandomNumberTriviaUseCase,
    this._typeConverter,
  ) : super(Empty()) {
    on<GetConcreteNumberTriviaEvent>(_onGetConcreteNumberTrivia);
    on<GetRandomNumberTriviaEvent>(_onGetRandomNumberTrivia);
  }

  void _onGetConcreteNumberTrivia(
    GetConcreteNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) {
    emit(Loading());
    Either<Failure, int> converterNumber =
        _typeConverter.toUnsignedInteger(event.number);
    converterNumber.fold(
      (failure) {
        emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      },
      (convertedNumber) async {
        final result =
            await _getConcreteNumberTriviaUseCase(Params(convertedNumber));
        result.fold((failure) {
          emit(
            Error(
              message: _mapToErrorMessage(failure),
            ),
          );
        }, (numberTrivia) {
          emit(Loaded(trivia: numberTrivia));
        });
      },
    );
  }

  void _onGetRandomNumberTrivia(
    GetRandomNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final result = await _getRandomNumberTriviaUseCase(NoParams());
    result.fold((failure) {
      emit(
        Error(
          message: _mapToErrorMessage(failure),
        ),
      );
    }, (numberTrivia) {
      emit(Loaded(trivia: numberTrivia));
    });
  }

  String _mapToErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
