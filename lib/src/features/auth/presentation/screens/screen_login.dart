import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/core/utils/validators.dart';
import 'package:hajjmate/src/features/auth/domain/entities/login_params.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_state.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';
import 'package:hajjmate/src/shared/widgets/inputfields/base_input.dart';
import 'package:hajjmate/src/shared/widgets/toast/app_toast.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginBloc>().add(
      LoginSubmitted(
        LoginParams(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.go(AppRoutes.homeFor(state.user.role));
            }
            if (state is LoginFailure) showAppToast(context, state.message);
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
                    Text(AppConstants.appName, style: textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('Sign in to continue', style: textTheme.bodyLarge),
                    const SizedBox(height: 32),
                    BaseInput(
                      label: 'Email',
                      controller: _emailController,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    BaseInput(
                      label: 'Password',
                      controller: _passwordController,
                      validator: Validators.password,
                      textInputAction: TextInputAction.done,
                      isPassword: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(AppRoutes.forgotPassword),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    BaseButton(
                      label: 'Sign in',
                      onPressed: _submit,
                      isLoading: state is LoginSubmitting,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signUp),
                      child: const Text('Create an account'),
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
