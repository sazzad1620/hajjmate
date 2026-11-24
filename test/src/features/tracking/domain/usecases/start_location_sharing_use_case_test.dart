import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/start_sharing_params.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/start_location_sharing_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDeviceLocationProvider extends Mock
    implements DeviceLocationProvider {}

class MockLocationSharingService extends Mock
    implements LocationSharingService {}

void main() {
  late MockDeviceLocationProvider locationProvider;
  late MockLocationSharingService sharingService;
  late StartLocationSharingUseCase useCase;

  const params = StartSharingParams(
    userId: 'u1',
    name: 'Rahim',
    groupId: 'default',
  );

  void stubStart({required bool result}) {
    when(
      () => sharingService.start(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        groupId: any(named: 'groupId'),
      ),
    ).thenAnswer((_) async => result);
  }

  setUp(() {
    locationProvider = MockDeviceLocationProvider();
    sharingService = MockLocationSharingService();
    useCase = StartLocationSharingUseCase(locationProvider, sharingService);
  });

  group('StartLocationSharingUseCase', () {
    test('starts the service when location is allowed', () async {
      when(
        () => locationProvider.requestPermissions(),
      ).thenAnswer((_) async => true);
      stubStart(result: true);

      final result = await useCase.execute(params);

      expect(result, const Right(unit));
      verify(
        () => sharingService.start(
          userId: 'u1',
          name: 'Rahim',
          groupId: 'default',
        ),
      ).called(1);
    });

    test('does not start the service when location is refused', () async {
      when(
        () => locationProvider.requestPermissions(),
      ).thenAnswer((_) async => false);

      final result = await useCase.execute(params);

      expect(result.isLeft(), isTrue);
      expect(
        result.swap().getOrElse(() => const UnknownFailure()),
        isA<PermissionFailure>(),
      );
      verifyNever(
        () => sharingService.start(
          userId: any(named: 'userId'),
          name: any(named: 'name'),
          groupId: any(named: 'groupId'),
        ),
      );
    });

    test('returns a failure when a plugin throws', () async {
      when(
        () => locationProvider.requestPermissions(),
      ).thenThrow(Exception('plugin error'));

      final result = await useCase.execute(params);

      expect(result, const Left(UnknownFailure()));
    });

    test('returns a failure when the service cannot start', () async {
      when(
        () => locationProvider.requestPermissions(),
      ).thenAnswer((_) async => true);
      stubStart(result: false);

      final result = await useCase.execute(params);

      expect(result, const Left(UnknownFailure()));
    });
  });
}
