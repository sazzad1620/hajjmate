import 'package:flutter/material.dart';

class ShellDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  static const List<ShellDestination> leader = [
    ShellDestination(
      label: 'Map',
      icon: Icons.map_outlined,
      selectedIcon: Icons.map_rounded,
    ),
    ShellDestination(
      label: 'Zones',
      icon: Icons.pin_drop_outlined,
      selectedIcon: Icons.pin_drop_rounded,
    ),
    ShellDestination(
      label: 'Alerts',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications_rounded,
    ),
    ShellDestination(
      label: 'More',
      icon: Icons.menu_rounded,
      selectedIcon: Icons.menu_rounded,
    ),
  ];

  static const List<ShellDestination> hajji = [
    ShellDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    ShellDestination(
      label: 'Map',
      icon: Icons.map_outlined,
      selectedIcon: Icons.map_rounded,
    ),
    ShellDestination(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];
}
