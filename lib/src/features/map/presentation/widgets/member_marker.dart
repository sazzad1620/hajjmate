import 'package:flutter/material.dart';
import 'package:hajjmate/src/shared/theme/app_typography.dart';

class MemberMarker extends StatelessWidget {
  final String name;
  final bool isStale;
  final VoidCallback onTap;

  const MemberMarker({
    super.key,
    required this.name,
    required this.isStale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = isStale ? colors.onSurfaceVariant : colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color),
            ),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.small.copyWith(color: colors.onSurface),
            ),
          ),
          Icon(Icons.location_on, size: 40, color: color),
        ],
      ),
    );
  }
}
