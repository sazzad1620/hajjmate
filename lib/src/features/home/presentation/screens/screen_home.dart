import 'package:flutter/material.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
