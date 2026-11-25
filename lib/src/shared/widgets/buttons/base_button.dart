import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  final bool isPrimary;

  const BaseButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final child = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: isPrimary ? colors.onPrimary : colors.primary,
            ),
          )
        : Text(label);
    // While loading, taps are ignored but the colours stay the same.
    final handler = isLoading ? () {} : onPressed;

    return isPrimary
        ? FilledButton(onPressed: handler, child: child)
        : ElevatedButton(onPressed: handler, child: child);
  }
}
