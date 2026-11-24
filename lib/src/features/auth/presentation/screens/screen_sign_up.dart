import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/core/utils/validators.dart';
import 'package:hajjmate/src/features/auth/domain/entities/role.dart';
import 'package:hajjmate/src/features/auth/domain/entities/sign_up_params.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_state.dart';
import 'package:hajjmate/src/features/auth/presentation/widgets/auth_switch_link.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';
import 'package:hajjmate/src/shared/widgets/inputfields/base_input.dart';
import 'package:hajjmate/src/shared/widgets/toast/app_toast.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});

  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Role? _submittingRole;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(Role role) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _submittingRole = role;
    context.read<SignUpBloc>().add(
      SignUpSubmitted(
        SignUpParams(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: role,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              context.go(AppRoutes.homeFor(state.user.role));
            }
            if (state is SignUpFailure) showAppToast(context, state.message);
          },
          builder: (context, state) {
            final isSubmitting = state is SignUpSubmitting;

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
                    Text('Create your account', style: textTheme.bodyLarge),
                    const SizedBox(height: 32),
                    BaseInput(
                      label: 'Full name',
                      controller: _nameController,
                      validator: Validators.name,
                    ),
                    const SizedBox(height: 16),
                    BaseInput(
                      label: 'Phone number',
                      controller: _phoneController,
                      validator: Validators.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 32),
                    BaseButton(
                      label: 'Sign up as Hajji',
                      onPressed: isSubmitting
                          ? null
                          : () => _submit(Role.hajji),
                      isLoading: isSubmitting && _submittingRole == Role.hajji,
                    ),
                    const SizedBox(height: 16),
                    BaseButton(
                      label: 'Sign up as Leader',
                      isPrimary: false,
                      onPressed: isSubmitting
                          ? null
                          : () => _submit(Role.leader),
                      isLoading: isSubmitting && _submittingRole == Role.leader,
                    ),
                    const SizedBox(height: 16),
                    AuthSwitchLink(
                      message: 'Already have an account?',
                      actionLabel: 'Sign in',
                      onTap: () => context.go(AppRoutes.login),
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
