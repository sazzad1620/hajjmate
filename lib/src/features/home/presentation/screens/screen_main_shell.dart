import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/features/home/presentation/shell_destination.dart';
import 'package:hajjmate/src/features/home/presentation/widgets/bottom_nav_bar.dart';

class ScreenMainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<ShellDestination> destinations;

  const ScreenMainShell({
    super.key,
    required this.navigationShell,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        destinations: destinations,
        selectedIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
