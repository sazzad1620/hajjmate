import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/domain/entities/update_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/update_zone_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:mocktail/mocktail.dart';

class MockZoneRepository extends Mock implements ZoneRepository {}

class FakeZone extends Fake implements Zone {}

void main() {
  late MockZoneRepository repository;
  late UpdateZoneUseCase useCase;

  final zone = Zone(
    id: 'z1',
    groupId: 'default',
    name: 'Hotel',
    centre: const Coordinates(latitude: 21.4225, longitude: 39.8262),
    radiusM: 150,
  );

  setUpAll(() => registerFallbackValue(FakeZone()));

  setUp(() {
    repository = MockZoneRepository();
    useCase = UpdateZoneUseCase(repository);
    when(
      () => repository.updateZone(any()),
    ).thenAnswer((_) async => const Right(unit));
  });

  group('UpdateZoneUseCase', () {
    test('saves the new name and radius and keeps id and centre', () async {
      final result = await useCase.execute(
        UpdateZoneParams(zone: zone, name: ' Camp ', radiusM: 300),
      );

      expect(result, const Right<Failure, Unit>(unit));
      final saved =
          verify(() => repository.updateZone(captureAny())).captured.single
              as Zone;
      expect(saved.id, 'z1');
      expect(saved.name, 'Camp');
      expect(saved.radiusM, 300);
      expect(saved.centre, zone.centre);
    });

    test('refuses a radius below 100 m', () async {
      final result = await useCase.execute(
        UpdateZoneParams(zone: zone, name: 'Hotel', radiusM: 50),
      );

      expect(
        result.swap().getOrElse(() => const UnknownFailure()),
        isA<ValidationFailure>(),
      );
      verifyNever(() => repository.updateZone(any()));
    });
  });
}
