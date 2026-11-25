import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';

// A use case whose result keeps changing, such as live data.
abstract interface class StreamUseCase<Input, Output> {
  Stream<Either<Failure, Output>> execute(Input input);
}
