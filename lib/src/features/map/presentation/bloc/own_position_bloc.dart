import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/own_position_event.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/own_position_state.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/watch_own_position_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class OwnPositionBloc extends Bloc<OwnPositionEvent, OwnPositionState> {
  final WatchOwnPositionUseCase _watchOwnPosition;

  OwnPositionBloc(this._watchOwnPosition) : super(const OwnPositionState()) {
    on<OwnPositionStarted>(_onStarted);
  }

  Future<void> _onStarted(
    OwnPositionStarted event,
    Emitter<OwnPositionState> emit,
  ) {
    return emit.forEach<Either<Failure, Coordinates>>(
      _watchOwnPosition.execute(const NoParams()),
      onData: (result) => result.fold(
        (_) => const OwnPositionState(),
        (position) => OwnPositionState(position: position),
      ),
    );
  }
}
