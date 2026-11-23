import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';

abstract interface class UseCase<Input, Output> {
  Future<Either<Failure, Output>> execute(Input input);
}
