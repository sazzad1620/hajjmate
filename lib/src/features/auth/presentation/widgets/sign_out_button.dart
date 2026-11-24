import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/di/injection_container.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_state.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';
import 'package:hajjmate/src/shared/widgets/toast/app_toast.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignOutBloc>(),
      child: BlocConsumer<SignOutBloc, SignOutState>(
        listener: (context, state) {
          if (state is SignOutSuccess) context.go(AppRoutes.login);
          if (state is SignOutFailure) showAppToast(context, state.message);
        },
        builder: (context, state) {
          return BaseButton(
            label: 'Sign out',
            isPrimary: false,
            onPressed: () =>
                context.read<SignOutBloc>().add(const SignOutRequested()),
            isLoading: state is SignOutSubmitting,
          );
        },
      ),
    );
  }
}
