import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/watch_alerts_params.dart';
import 'package:hajjmate/src/features/alerts/domain/usecases/watch_alerts_use_case.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_bloc.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_event.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_state.dart';
import 'package:hajjmate/src/features/auth/domain/entities/leader.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUserUseCase {}

class MockWatchAlerts extends Mock implements WatchAlertsUseCase {}

void main() {
  late MockGetCurrentUser getCurrentUser;
  late MockWatchAlerts watchAlerts;

  final alert = Alert(
    type: AlertType.exit,
    groupId: 'default',
    userId: 'u1',
    userName: 'Rahim',
    zoneId: 'z1',
    zoneName: 'Hotel',
    position: const Coordinates(latitude: 21.4225, longitude: 39.8262),
    timestamp: DateTime(2026, 11, 25),
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const WatchAlertsParams(groupId: 'default'));
  });

  setUp(() {
    getCurrentUser = MockGetCurrentUser();
    watchAlerts = MockWatchAlerts();
    when(() => getCurrentUser.execute(any())).thenAnswer(
      (_) async => const Right(
        Leader(
          id: 'l1',
          name: 'Karim',
          phone: '01700000001',
          email: 'karim@example.com',
          groupId: 'default',
        ),
      ),
    );
  });

  group('AlertListBloc', () {
    test('shows the alerts it receives', () async {
      when(
        () => watchAlerts.execute(any()),
      ).thenAnswer((_) => Stream.value(Right<Failure, List<Alert>>([alert])));
      final bloc = AlertListBloc(getCurrentUser, watchAlerts)
        ..add(const AlertListStarted());

      await expectLater(
        bloc.stream,
        emits(AlertListState(status: AlertListStatus.ready, alerts: [alert])),
      );
      await bloc.close();
    });

    test('shows a failure from the stream', () async {
      when(() => watchAlerts.execute(any())).thenAnswer(
        (_) => Stream.value(const Left<Failure, List<Alert>>(NetworkFailure())),
      );
      final bloc = AlertListBloc(getCurrentUser, watchAlerts)
        ..add(const AlertListStarted());

      final state = await bloc.stream.first;

      expect(state.status, AlertListStatus.failure);
      await bloc.close();
    });
  });
}
