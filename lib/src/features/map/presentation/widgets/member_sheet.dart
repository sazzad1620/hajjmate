import 'package:flutter/material.dart';
import 'package:hajjmate/src/core/utils/time_formatter.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';

class MemberSheet extends StatelessWidget {
  final LocationUpdate member;

  const MemberSheet({super.key, required this.member});

  static Future<void> show(BuildContext context, LocationUpdate member) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => MemberSheet(member: member),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.name, style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Last update ${TimeFormatter.clock(member.timestamp)} '
              '(${TimeFormatter.ago(member.timestamp)})',
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
