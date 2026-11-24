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
import 'package:hajjmate/src/features/home/presentation/screens/screen_home.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ScreenHome(),
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
    ],
  );
}
