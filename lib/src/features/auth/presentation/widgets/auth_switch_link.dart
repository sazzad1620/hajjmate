import 'package:flutter/material.dart';

class AuthSwitchLink extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(message, style: Theme.of(context).textTheme.bodyLarge),
        TextButton(onPressed: onTap, child: Text(actionLabel)),
      ],
    );
  }
}
