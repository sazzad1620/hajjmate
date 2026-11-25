import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/domain/entities/geofence_context.dart';
import 'package:hajjmate/src/features/zones/domain/entities/sync_geofences_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_context_store.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_registry.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/sync_geofences_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:mocktail/mocktail.dart';

class MockGeofenceRegistry extends Mock implements GeofenceRegistry {}

class MockGeofenceContextStore extends Mock implements GeofenceContextStore {}

class FakeGeofenceContext extends Fake implements GeofenceContext {}

void main() {
  late MockGeofenceRegistry registry;
  late MockGeofenceContextStore store;
  late SyncGeofencesUseCase useCase;

  final params = SyncGeofencesParams(
    userId: 'u1',
    userName: 'Rahim',
    groupId: 'default',
    zones: [
      Zone(
        id: 'z1',
        groupId: 'default',
        name: 'Hotel',
        centre: const Coordinates(latitude: 21.4225, longitude: 39.8262),
        radiusM: 150,
      ),
    ],
  );

  setUpAll(() => registerFallbackValue(FakeGeofenceContext()));

  setUp(() {
    registry = MockGeofenceRegistry();
    store = MockGeofenceContextStore();
    useCase = SyncGeofencesUseCase(registry, store);
    when(() => store.save(any())).thenAnswer((_) async {});
  });

  group('SyncGeofencesUseCase', () {
    test('saves what the callback needs, then registers the zones', () async {
      when(
        () => registry.sync(params.zones),
      ).thenAnswer((_) async => const Right(1));

      final result = await useCase.execute(params);

      expect(result, const Right<Failure, int>(1));
      verifyInOrder([
        () => store.save(
          const GeofenceContext(
            userId: 'u1',
            userName: 'Rahim',
            groupId: 'default',
            zoneNames: {'z1': 'Hotel'},
          ),
        ),
        () => registry.sync(params.zones),
      ]);
    });

    test('does not register when saving fails', () async {
      when(() => store.save(any())).thenThrow(Exception('disk'));

      final result = await useCase.execute(params);

      expect(result, const Left<Failure, int>(UnknownFailure()));
      verifyNever(() => registry.sync(any()));
    });
  });
}
