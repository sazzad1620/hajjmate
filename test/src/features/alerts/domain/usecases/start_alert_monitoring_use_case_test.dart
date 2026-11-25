import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/watch_alerts_params.dart';
import 'package:hajjmate/src/features/alerts/domain/services/alert_monitor_service.dart';
import 'package:hajjmate/src/features/alerts/domain/usecases/start_alert_monitoring_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAlertMonitorService extends Mock implements AlertMonitorService {}

void main() {
  late MockAlertMonitorService service;
  late StartAlertMonitoringUseCase useCase;

  const params = WatchAlertsParams(groupId: 'default');

  setUp(() {
    service = MockAlertMonitorService();
    useCase = StartAlertMonitoringUseCase(service);
  });

  group('StartAlertMonitoringUseCase', () {
    test('succeeds when the service starts', () async {
      when(
        () => service.start(groupId: 'default'),
      ).thenAnswer((_) async => true);

      expect(await useCase.execute(params), const Right<Failure, Unit>(unit));
    });

    test('fails when the service does not start', () async {
      when(
        () => service.start(groupId: 'default'),
      ).thenAnswer((_) async => false);

      final result = await useCase.execute(params);

      expect(result.isLeft(), isTrue);
    });

    test('turns a plugin error into a failure', () async {
      when(() => service.start(groupId: 'default')).thenThrow(Exception('no'));

      final result = await useCase.execute(params);

      expect(result.isLeft(), isTrue);
    });
  });
}
