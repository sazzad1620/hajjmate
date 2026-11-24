import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/core/utils/validators.dart';
import 'package:hajjmate/src/features/auth/domain/entities/forgot_password_params.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_state.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';
import 'package:hajjmate/src/shared/widgets/inputfields/base_input.dart';
import 'package:hajjmate/src/shared/widgets/toast/app_toast.dart';

class ScreenForgotPassword extends StatefulWidget {
  const ScreenForgotPassword({super.key});

  @override
  State<ScreenForgotPassword> createState() => _ScreenForgotPasswordState();
}

class _ScreenForgotPasswordState extends State<ScreenForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordSubmitted(
        ForgotPasswordParams(email: _emailController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              showAppToast(context, 'Reset link sent. Check your email.');
              context.pop();
            }
            if (state is ForgotPasswordFailure) {
              showAppToast(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Text('Reset password', style: textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your email and we will send you a link to reset your password.',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    BaseInput(
                      label: 'Email',
                      controller: _emailController,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),
                    BaseButton(
                      label: 'Send reset link',
                      onPressed: _submit,
                      isLoading: state is ForgotPasswordSubmitting,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to sign in'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
