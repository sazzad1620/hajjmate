import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/watch_group_params.dart';
import 'package:hajjmate/src/features/tracking/domain/repositories/location_repository.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/watch_group_locations_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late MockLocationRepository repository;
  late WatchGroupLocationsUseCase useCase;

  const params = WatchGroupParams(groupId: 'default');
  final locations = [
    LocationUpdate(
      userId: 'u1',
      name: 'Rahim',
      groupId: 'default',
      position: const Coordinates(latitude: 21.4225, longitude: 39.8262),
      timestamp: DateTime(2026, 11, 25, 9, 30),
    ),
  ];

  setUp(() {
    repository = MockLocationRepository();
    useCase = WatchGroupLocationsUseCase(repository);
  });

  group('WatchGroupLocationsUseCase', () {
    test('passes on every list the repository emits', () {
      final first = Right<Failure, List<LocationUpdate>>(locations);
      const second = Right<Failure, List<LocationUpdate>>([]);
      when(
        () => repository.watchGroup('default'),
      ).thenAnswer((_) => Stream.fromIterable([first, second]));

      expect(useCase.execute(params), emitsInOrder([first, second]));
    });

    test('passes on a failure', () {
      const failure = NetworkFailure();
      when(() => repository.watchGroup('default')).thenAnswer(
        (_) => Stream.value(const Left<Failure, List<LocationUpdate>>(failure)),
      );

      expect(
        useCase.execute(params),
        emits(const Left<Failure, List<LocationUpdate>>(failure)),
      );
    });
  });
}
