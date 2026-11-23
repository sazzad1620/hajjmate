import 'package:flutter/material.dart';
import 'package:hajjmate/src/config/router/app_router.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/shared/theme/app_theme.dart';

class HajjMateApp extends StatelessWidget {
  const HajjMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.light,
      routerConfig: createAppRouter(),
    );
  }
}
