import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/di/injection_container.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
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
import 'package:hajjmate/src/features/map/presentation/screens/screen_leader_map.dart';
import 'package:hajjmate/src/features/profile/presentation/screens/screen_hajji_profile.dart';
import 'package:hajjmate/src/features/profile/presentation/screens/screen_leader_more.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_bloc.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_event.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_event.dart';
import 'package:hajjmate/src/features/splash/presentation/screens/screen_splash.dart';
import 'package:hajjmate/src/shared/widgets/layouts/placeholder_tab.dart';

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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ScreenMainShell(
          navigationShell: navigationShell,
          destinations: ShellDestination.leader,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderMap,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<GroupMapBloc>()..add(const GroupMapStarted()),
                  child: const ScreenLeaderMap(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderZones,
                builder: (context, state) =>
                    const PlaceholderTab(title: 'Zones'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderAlerts,
                builder: (context, state) =>
                    const PlaceholderTab(title: 'Alerts'),
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
        builder: (context, state, navigationShell) => ScreenMainShell(
          navigationShell: navigationShell,
          destinations: ShellDestination.hajji,
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
                builder: (context, state) => const PlaceholderTab(title: 'Map'),
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
