import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/stop_location_sharing_use_case.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationSharingService extends Mock
    implements LocationSharingService {}

void main() {
  test('StopLocationSharingUseCase stops the service', () async {
    final sharingService = MockLocationSharingService();
    when(() => sharingService.stop()).thenAnswer((_) async {});
    final useCase = StopLocationSharingUseCase(sharingService);

    final result = await useCase.execute(const NoParams());

    expect(result, const Right(unit));
    verify(() => sharingService.stop()).called(1);
  });
}
