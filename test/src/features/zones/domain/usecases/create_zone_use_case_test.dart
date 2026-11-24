import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/domain/entities/create_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/create_zone_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:mocktail/mocktail.dart';

class MockZoneRepository extends Mock implements ZoneRepository {}

class FakeZone extends Fake implements Zone {}

void main() {
  late MockZoneRepository repository;
  late CreateZoneUseCase useCase;

  const centre = Coordinates(latitude: 21.4225, longitude: 39.8262);
  const params = CreateZoneParams(
    groupId: 'default',
    name: ' Hotel ',
    centre: centre,
    radiusM: 150,
  );

  setUpAll(() => registerFallbackValue(FakeZone()));

  setUp(() {
    repository = MockZoneRepository();
    useCase = CreateZoneUseCase(repository);
    when(
      () => repository.createZone(any()),
    ).thenAnswer((_) async => const Right(unit));
  });

  void givenCount(int count) => when(
    () => repository.countZones('default'),
  ).thenAnswer((_) async => Right(count));

  group('CreateZoneUseCase', () {
    test('creates a trimmed zone when there is room', () async {
      givenCount(9);

      final result = await useCase.execute(params);

      expect(result, const Right<Failure, Unit>(unit));
      final created =
          verify(() => repository.createZone(captureAny())).captured.single
              as Zone;
      expect(created.name, 'Hotel');
      expect(created.radiusM, 150);
    });

    test('refuses the 11th zone', () async {
      givenCount(10);

      final result = await useCase.execute(params);

      expect(result.isLeft(), isTrue);
      expect(
        result.swap().getOrElse(() => const UnknownFailure()),
        isA<ValidationFailure>(),
      );
      verifyNever(() => repository.createZone(any()));
    });

    test('refuses a radius below 100 m', () async {
      givenCount(0);

      final result = await useCase.execute(
        const CreateZoneParams(
          groupId: 'default',
          name: 'Hotel',
          centre: centre,
          radiusM: 50,
        ),
      );

      expect(
        result.swap().getOrElse(() => const UnknownFailure()),
        isA<ValidationFailure>(),
      );
      verifyNever(() => repository.createZone(any()));
    });

    test('passes on a failure from counting', () async {
      when(
        () => repository.countZones('default'),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await useCase.execute(params);

      expect(result, const Left<Failure, Unit>(NetworkFailure()));
      verifyNever(() => repository.createZone(any()));
    });
  });
}
