import 'package:flutter/material.dart';
import 'package:hajjmate/src/features/tracking/presentation/widgets/location_sharing_card.dart';

class ScreenHajjiHome extends StatelessWidget {
  const ScreenHajjiHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
            Text('Home', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            const LocationSharingCard(),
          ],
        ),
      ),
    );
  }
}
