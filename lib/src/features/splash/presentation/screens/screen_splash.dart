import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_state.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          context.go(AppRoutes.homeFor(state.user.role));
        }
        if (state is SplashUnauthenticated) context.go(AppRoutes.login);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
