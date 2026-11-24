import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/group_map_event.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/group_map_state.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/watch_group_params.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/watch_group_locations_use_case.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class GroupMapBloc extends Bloc<GroupMapEvent, GroupMapState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final WatchGroupLocationsUseCase _watchGroupLocations;

  GroupMapBloc(this._getCurrentUser, this._watchGroupLocations)
    : super(const GroupMapState()) {
    on<GroupMapStarted>(_onStarted);
  }

  Future<void> _onStarted(
    GroupMapStarted event,
    Emitter<GroupMapState> emit,
  ) async {
    final userResult = await _getCurrentUser.execute(const NoParams());
    final user = userResult.fold((_) => null, (user) => user);
    if (user == null) {
      emit(
        const GroupMapState(
          status: MapStatus.failure,
          message: 'Could not load your profile. Sign in again.',
        ),
      );
      return;
    }

    await emit.forEach<Either<Failure, List<LocationUpdate>>>(
      _watchGroupLocations.execute(WatchGroupParams(groupId: user.groupId)),
      onData: (result) => result.fold(
        (failure) => GroupMapState(
          status: MapStatus.failure,
          members: state.members,
          message: failure.message,
        ),
        (members) => GroupMapState(status: MapStatus.ready, members: members),
      ),
    );
  }
}
