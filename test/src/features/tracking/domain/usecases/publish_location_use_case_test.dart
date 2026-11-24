import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/tracking/domain/repositories/location_repository.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/publish_location_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late MockLocationRepository repository;
  late PublishLocationUseCase useCase;

  final update = LocationUpdate(
    userId: 'u1',
    name: 'Rahim',
    groupId: 'default',
    position: const Coordinates(latitude: 21.4225, longitude: 39.8262),
    timestamp: DateTime(2026, 11, 25, 9, 30),
  );

  setUp(() {
    repository = MockLocationRepository();
    useCase = PublishLocationUseCase(repository);
  });

  group('PublishLocationUseCase', () {
    test('returns unit when the location is published', () async {
      when(
        () => repository.publish(update),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase.execute(update);

      expect(result, const Right(unit));
      verify(() => repository.publish(update)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns the failure when there is no connection', () async {
      const failure = NetworkFailure();
      when(
        () => repository.publish(update),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase.execute(update);

      expect(result, const Left(failure));
    });
  });
}
