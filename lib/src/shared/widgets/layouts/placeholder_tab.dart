import 'package:flutter/material.dart';

class PlaceholderTab extends StatelessWidget {
  final String title;

  const PlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
    );
  }
}
