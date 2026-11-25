import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/entities/hajji.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/watch_zones_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/clear_geofences_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/request_geofence_permission_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/sync_geofences_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/watch_zones_use_case.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_state.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUserUseCase {}

class MockWatchZones extends Mock implements WatchZonesUseCase {}

class MockSync extends Mock implements SyncGeofencesUseCase {}

class MockClear extends Mock implements ClearGeofencesUseCase {}

class MockRequestPermission extends Mock
    implements RequestGeofencePermissionUseCase {}

void main() {
  late MockGetCurrentUser getCurrentUser;
  late MockWatchZones watchZones;
  late MockSync sync;
  late MockClear clear;
  late MockRequestPermission requestPermission;
  late GeofenceSyncBloc bloc;

  final zone = Zone(
    id: 'z1',
    groupId: 'default',
    name: 'Hotel',
    centre: const Coordinates(latitude: 21.4225, longitude: 39.8262),
    radiusM: 150,
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const WatchZonesParams(groupId: 'default'));
    registerFallbackValue(<Zone>[]);
  });

  setUp(() {
    getCurrentUser = MockGetCurrentUser();
    watchZones = MockWatchZones();
    sync = MockSync();
    clear = MockClear();
    requestPermission = MockRequestPermission();
    when(() => getCurrentUser.execute(any())).thenAnswer(
      (_) async => const Right(
        Hajji(
          id: 'u1',
          name: 'Rahim',
          phone: '01700000000',
          email: 'rahim@example.com',
          groupId: 'default',
        ),
      ),
    );
    when(() => clear.execute(any())).thenAnswer((_) async => const Right(unit));
    bloc = GeofenceSyncBloc(
      getCurrentUser,
      watchZones,
      sync,
      clear,
      requestPermission,
    );
  });

  tearDown(() => bloc.close());

  group('GeofenceSyncBloc', () {
    test('registers the zones it receives', () async {
      when(
        () => watchZones.execute(any()),
      ).thenAnswer((_) => Stream.value(Right([zone])));
      when(() => sync.execute(any())).thenAnswer((_) async => const Right(1));

      bloc.add(const GeofenceSyncStarted());

      await expectLater(
        bloc.stream,
        emits(
          const GeofenceSyncState(
            status: GeofenceSyncStatus.active,
            registeredCount: 1,
          ),
        ),
      );
      verify(() => sync.execute([zone])).called(1);
    });

    test('asks for permission when "all the time" is missing', () async {
      when(
        () => watchZones.execute(any()),
      ).thenAnswer((_) => Stream.value(Right([zone])));
      when(() => sync.execute(any())).thenAnswer(
        (_) async => const Left(PermissionFailure(message: 'Allow it.')),
      );

      bloc.add(const GeofenceSyncStarted());

      await expectLater(
        bloc.stream,
        emits(
          const GeofenceSyncState(
            status: GeofenceSyncStatus.permissionMissing,
            message: 'Allow it.',
          ),
        ),
      );
    });

    test('clears every geofence when it is closed', () async {
      await bloc.close();

      verify(() => clear.execute(any())).called(1);
    });
  });
}
