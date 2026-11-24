import 'package:flutter/material.dart';
import 'package:hajjmate/src/features/auth/presentation/widgets/sign_out_button.dart';

class ScreenHajjiHome extends StatelessWidget {
  const ScreenHajjiHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hajji home',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              const SignOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
