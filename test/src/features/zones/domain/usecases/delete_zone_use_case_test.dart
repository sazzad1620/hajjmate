import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/domain/entities/delete_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/delete_zone_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockZoneRepository extends Mock implements ZoneRepository {}

void main() {
  late MockZoneRepository repository;
  late DeleteZoneUseCase useCase;

  const params = DeleteZoneParams(zoneId: 'z1');

  setUp(() {
    repository = MockZoneRepository();
    useCase = DeleteZoneUseCase(repository);
  });

  group('DeleteZoneUseCase', () {
    test('returns unit when the zone is deleted', () async {
      when(
        () => repository.deleteZone('z1'),
      ).thenAnswer((_) async => const Right(unit));

      expect(await useCase.execute(params), const Right<Failure, Unit>(unit));
    });

    test('returns the failure when there is no connection', () async {
      when(
        () => repository.deleteZone('z1'),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      expect(
        await useCase.execute(params),
        const Left<Failure, Unit>(NetworkFailure()),
      );
    });
  });
}
