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
import 'package:hajjmate/src/features/home/presentation/screens/screen_leader_home.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_bloc.dart';
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
        path: AppRoutes.leaderHome,
        builder: (context, state) => const ScreenLeaderHome(),
      ),
      GoRoute(
        path: AppRoutes.hajjiHome,
        builder: (context, state) => const ScreenHajjiHome(),
      ),
    ],
  );
}
