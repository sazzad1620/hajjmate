import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/watch_zones_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/watch_zones_use_case.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_state.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class ZoneListBloc extends Bloc<ZoneListEvent, ZoneListState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final WatchZonesUseCase _watchZones;

  ZoneListBloc(this._getCurrentUser, this._watchZones)
    : super(const ZoneListState()) {
    on<ZoneListStarted>(_onStarted);
  }

  Future<void> _onStarted(
    ZoneListStarted event,
    Emitter<ZoneListState> emit,
  ) async {
    final userResult = await _getCurrentUser.execute(const NoParams());
    final user = userResult.fold((_) => null, (user) => user);
    if (user == null) {
      emit(
        const ZoneListState(
          status: ZoneListStatus.failure,
          message: 'Could not load your profile. Sign in again.',
        ),
      );
      return;
    }

    await emit.forEach<Either<Failure, List<Zone>>>(
      _watchZones.execute(WatchZonesParams(groupId: user.groupId)),
      onData: (result) => result.fold(
        (failure) => ZoneListState(
          status: ZoneListStatus.failure,
          zones: state.zones,
          message: failure.message,
        ),
        (zones) => ZoneListState(status: ZoneListStatus.ready, zones: zones),
      ),
    );
  }
}
