import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hajjmate/src/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/group_map_bloc.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:hajjmate/src/features/tracking/data/repositories/realtime_location_repository.dart';
import 'package:hajjmate/src/features/tracking/data/services/foreground_location_sharing_service.dart';
import 'package:hajjmate/src/features/tracking/data/services/geolocator_device_location_provider.dart';
import 'package:hajjmate/src/features/tracking/domain/repositories/location_repository.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/get_sharing_status_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/start_location_sharing_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/stop_location_sharing_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/watch_group_locations_use_case.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_bloc.dart';
import 'package:hajjmate/src/features/zones/data/repositories/firestore_zone_repository.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/create_zone_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/watch_zones_use_case.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_bloc.dart';

final GetIt getIt = GetIt.instance;

// Each feature registers its classes in its own function, interface first.
void configureDependencies() {
  _registerCore();
  _registerAuth();
  _registerTracking();
  _registerMap();
  _registerZones();
  _registerSplash();
}

void _registerCore() {
  getIt
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance)
    ..registerLazySingleton<ErrorHandler>(ErrorHandler.new);
}

void _registerAuth() {
  getIt
    ..registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(getIt(), getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(getIt(), getIt()),
    )
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()))
    ..registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(getIt()))
    ..registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(getIt()),
    )
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt()),
    )
    ..registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(getIt()))
    ..registerFactory<LoginBloc>(() => LoginBloc(getIt()))
    ..registerFactory<SignUpBloc>(() => SignUpBloc(getIt()))
    ..registerFactory<ForgotPasswordBloc>(() => ForgotPasswordBloc(getIt()))
    ..registerFactory<SignOutBloc>(() => SignOutBloc(getIt()));
}

void _registerTracking() {
  getIt
    ..registerLazySingleton<DeviceLocationProvider>(
      GeolocatorDeviceLocationProvider.new,
    )
    ..registerLazySingleton<LocationSharingService>(
      ForegroundLocationSharingService.new,
    )
    ..registerLazySingleton<LocationRepository>(
      () => RealtimeLocationRepository(getIt(), getIt()),
    )
    ..registerLazySingleton<StartLocationSharingUseCase>(
      () => StartLocationSharingUseCase(getIt(), getIt()),
    )
    ..registerLazySingleton<StopLocationSharingUseCase>(
      () => StopLocationSharingUseCase(getIt()),
    )
    ..registerLazySingleton<GetSharingStatusUseCase>(
      () => GetSharingStatusUseCase(getIt()),
    )
    ..registerLazySingleton<WatchGroupLocationsUseCase>(
      () => WatchGroupLocationsUseCase(getIt()),
    )
    ..registerFactory<LocationSharingBloc>(
      () => LocationSharingBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt<LocationSharingService>(),
      ),
    );
}

void _registerMap() {
  getIt.registerFactory<GroupMapBloc>(() => GroupMapBloc(getIt(), getIt()));
}

void _registerZones() {
  getIt
    ..registerLazySingleton<ZoneRepository>(
      () => FirestoreZoneRepository(getIt(), getIt()),
    )
    ..registerLazySingleton<WatchZonesUseCase>(() => WatchZonesUseCase(getIt()))
    ..registerLazySingleton<CreateZoneUseCase>(() => CreateZoneUseCase(getIt()))
    ..registerFactory<ZoneListBloc>(() => ZoneListBloc(getIt(), getIt()))
    ..registerFactory<ZoneFormBloc>(
      () => ZoneFormBloc(getIt(), getIt(), getIt()),
    );
}

void _registerSplash() {
  getIt.registerFactory<SplashBloc>(() => SplashBloc(getIt()));
}
