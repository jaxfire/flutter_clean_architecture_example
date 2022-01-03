import 'package:dartz/dartz.dart';
import 'package:tdd_clean_arch_learning/common/error/failures.dart';

class TypeConverter {
  Either<Failure, int> toUnsignedInteger(String str) {
    try {
      int result = int.parse(str);
      if (result < 0) {
        return Left(InvalidInputFailure());
      } else {
        return Right(result);
      }
    } on Exception {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
