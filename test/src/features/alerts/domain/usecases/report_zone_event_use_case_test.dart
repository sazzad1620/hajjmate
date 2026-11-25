import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/features/alerts/domain/repositories/alert_repository.dart';
import 'package:hajjmate/src/features/alerts/domain/services/notifier.dart';
import 'package:hajjmate/src/features/alerts/domain/usecases/report_zone_event_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:mocktail/mocktail.dart';

class MockAlertRepository extends Mock implements AlertRepository {}

class MockNotifier extends Mock implements Notifier {}

void main() {
  late MockAlertRepository repository;
  late MockNotifier notifier;
  late ReportZoneEventUseCase useCase;

  Alert alertOf(AlertType type) => Alert(
    type: type,
    groupId: 'default',
    userId: 'u1',
    userName: 'Rahim',
    zoneId: 'z1',
    zoneName: 'Hotel',
    position: const Coordinates(latitude: 21.4225, longitude: 39.8262),
    timestamp: DateTime(2026, 11, 25, 9, 30),
  );

  setUp(() {
    repository = MockAlertRepository();
    notifier = MockNotifier();
    useCase = ReportZoneEventUseCase(repository, notifier);
    when(
      () => notifier.show(
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async {});
  });

  group('ReportZoneEventUseCase', () {
    test('tells the Hajji and records an enter alert', () async {
      final alert = alertOf(AlertType.enter);
      when(
        () => repository.publish(alert),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase.execute(alert);

      expect(result, const Right<Failure, Unit>(unit));
      verify(
        () => notifier.show(title: 'Zone alert', body: 'You entered Hotel'),
      ).called(1);
    });

    test('says "left" for an exit alert', () async {
      final alert = alertOf(AlertType.exit);
      when(
        () => repository.publish(alert),
      ).thenAnswer((_) async => const Right(unit));

      await useCase.execute(alert);

      verify(
        () => notifier.show(title: 'Zone alert', body: 'You left Hotel'),
      ).called(1);
    });

    test('still shows the notification when the upload fails', () async {
      final alert = alertOf(AlertType.exit);
      when(
        () => repository.publish(alert),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await useCase.execute(alert);

      expect(result, const Left<Failure, Unit>(NetworkFailure()));
      verify(
        () => notifier.show(title: 'Zone alert', body: 'You left Hotel'),
      ).called(1);
    });

    test('still records the alert when the notification fails', () async {
      final alert = alertOf(AlertType.enter);
      when(
        () => notifier.show(
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenThrow(Exception('blocked'));
      when(
        () => repository.publish(alert),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase.execute(alert);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => repository.publish(alert)).called(1);
    });
  });
}
