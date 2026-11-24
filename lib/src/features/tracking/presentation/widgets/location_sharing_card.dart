import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/core/utils/time_formatter.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_bloc.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_event.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_state.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';
import 'package:hajjmate/src/shared/widgets/toast/app_toast.dart';

class LocationSharingCard extends StatelessWidget {
  const LocationSharingCard({super.key});

  Future<void> _confirmAndStart(BuildContext context) async {
    final bloc = context.read<LocationSharingBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share your location?'),
        content: const Text(
          'Your group leader will see where you are. Allow location access '
          'when asked.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (confirmed == true) bloc.add(const SharingStartRequested());
  }

  String _subtitle(LocationSharingState state) {
    final seconds = AppConstants.locationUpdateInterval.inSeconds;
    return switch (state.status) {
      SharingStatus.on =>
        state.lastSentAt == null
            ? 'Waiting for the first update'
            : 'Last sent ${TimeFormatter.clock(state.lastSentAt!)}. '
                  'Updates every $seconds seconds.',
      SharingStatus.starting => 'Starting...',
      _ => 'Your group leader cannot see where you are.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<LocationSharingBloc, LocationSharingState>(
      listenWhen: (previous, current) =>
          current.status == SharingStatus.failure &&
          previous.status != SharingStatus.failure,
      listener: (context, state) {
        if (state.message != null) showAppToast(context, state.message!);
      },
      builder: (context, state) {
        final isOn = state.status == SharingStatus.on;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Location sharing',
                        style: textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      isOn ? 'On' : 'Off',
                      style: textTheme.bodyLarge?.copyWith(
                        color: isOn ? colors.primary : colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _subtitle(state),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                if (isOn)
                  BaseButton(
                    label: 'Stop sharing',
                    isPrimary: false,
                    onPressed: () => context.read<LocationSharingBloc>().add(
                      const SharingStopRequested(),
                    ),
                  )
                else
                  BaseButton(
                    label: 'Start sharing',
                    isLoading: state.status == SharingStatus.starting,
                    onPressed: () => _confirmAndStart(context),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
