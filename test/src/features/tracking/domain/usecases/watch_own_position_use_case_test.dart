import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/watch_own_position_use_case.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';
import 'package:mocktail/mocktail.dart';

class MockDeviceLocationProvider extends Mock
    implements DeviceLocationProvider {}

void main() {
  late MockDeviceLocationProvider provider;
  late WatchOwnPositionUseCase useCase;

  const position = Coordinates(latitude: 21.4225, longitude: 39.8262);

  setUp(() {
    provider = MockDeviceLocationProvider();
    useCase = WatchOwnPositionUseCase(provider);
  });

  group('WatchOwnPositionUseCase', () {
    test('passes on each position of the phone', () async {
      when(
        () => provider.watchPosition(),
      ).thenAnswer((_) => Stream.value(position));

      expect(
        useCase.execute(const NoParams()),
        emits(const Right<Failure, Coordinates>(position)),
      );
    });

    test('turns a location error into a failure', () async {
      when(
        () => provider.watchPosition(),
      ).thenAnswer((_) => Stream.error(Exception('off')));

      final result = await useCase.execute(const NoParams()).first;

      expect(result.isLeft(), isTrue);
    });
  });
}
