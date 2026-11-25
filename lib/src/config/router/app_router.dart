import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/di/injection_container.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_bloc.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_event.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_monitor_bloc.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_monitor_event.dart';
import 'package:hajjmate/src/features/alerts/presentation/screens/screen_alerts.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/screens/screen_forgot_password.dart';
import 'package:hajjmate/src/features/auth/presentation/screens/screen_login.dart';
import 'package:hajjmate/src/features/auth/presentation/screens/screen_sign_up.dart';
import 'package:hajjmate/src/features/home/presentation/screens/screen_hajji_home.dart';
import 'package:hajjmate/src/features/home/presentation/screens/screen_main_shell.dart';
import 'package:hajjmate/src/features/home/presentation/shell_destination.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/group_map_bloc.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/group_map_event.dart';
import 'package:hajjmate/src/features/map/presentation/screens/screen_hajji_map.dart';
import 'package:hajjmate/src/features/map/presentation/screens/screen_leader_map.dart';
import 'package:hajjmate/src/features/profile/presentation/screens/screen_hajji_profile.dart';
import 'package:hajjmate/src/features/profile/presentation/screens/screen_leader_more.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_bloc.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_event.dart';
import 'package:hajjmate/src/features/zones/presentation/screens/screen_zone_form.dart';
import 'package:hajjmate/src/features/zones/presentation/screens/screen_zones.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_event.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_event.dart';
import 'package:hajjmate/src/features/splash/presentation/screens/screen_splash.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<SplashBloc>()..add(const SplashStarted()),
          child: const ScreenSplash(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LoginBloc>(),
          child: const ScreenLogin(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<SignUpBloc>(),
          child: const ScreenSignUp(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<ForgotPasswordBloc>(),
          child: const ScreenForgotPassword(),
        ),
      ),
      GoRoute(
        path: AppRoutes.zoneForm,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<ZoneFormBloc>()..add(const ZoneFormStarted()),
          child: const ScreenZoneForm(),
        ),
      ),
      GoRoute(
        path: AppRoutes.zoneEdit,
        builder: (context, state) {
          final zone = state.extra! as Zone;
          return BlocProvider(
            create: (_) =>
                getIt<ZoneFormBloc>()..add(ZoneFormStarted(zone: zone)),
            child: ScreenZoneForm(zone: zone),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => BlocProvider(
          create: (_) =>
              getIt<AlertMonitorBloc>()..add(const AlertMonitorStarted()),
          child: ScreenMainShell(
            navigationShell: navigationShell,
            destinations: ShellDestination.leader,
          ),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderMap,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          getIt<GroupMapBloc>()..add(const GroupMapStarted()),
                    ),
                    BlocProvider(
                      create: (_) =>
                          getIt<ZoneListBloc>()..add(const ZoneListStarted()),
                    ),
                  ],
                  child: const ScreenLeaderMap(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderZones,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<ZoneListBloc>()..add(const ZoneListStarted()),
                  child: const ScreenZones(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderAlerts,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<AlertListBloc>()..add(const AlertListStarted()),
                  child: const ScreenAlerts(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderMore,
                builder: (context, state) => const ScreenLeaderMore(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => BlocProvider(
          create: (_) =>
              getIt<GeofenceSyncBloc>()..add(const GeofenceSyncStarted()),
          child: ScreenMainShell(
            navigationShell: navigationShell,
            destinations: ShellDestination.hajji,
          ),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hajjiHome,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<LocationSharingBloc>()
                        ..add(const SharingStatusRequested()),
                  child: const ScreenHajjiHome(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hajjiMap,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<ZoneListBloc>()..add(const ZoneListStarted()),
                  child: const ScreenHajjiMap(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hajjiProfile,
                builder: (context, state) => const ScreenHajjiProfile(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
