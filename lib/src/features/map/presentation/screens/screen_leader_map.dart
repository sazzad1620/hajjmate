import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/group_map_bloc.dart';
import 'package:hajjmate/src/features/map/presentation/bloc/group_map_state.dart';
import 'package:hajjmate/src/features/map/presentation/widgets/group_map.dart';

class ScreenLeaderMap extends StatelessWidget {
  const ScreenLeaderMap({super.key});

  String _summary(GroupMapState state) {
    return switch (state.status) {
      MapStatus.loading => 'Loading...',
      MapStatus.failure => state.message ?? 'Could not load the map.',
      MapStatus.ready =>
        state.members.isEmpty
            ? 'No Hajji is sharing yet'
            : '${state.members.length} sharing',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupMapBloc, GroupMapState>(
        builder: (context, state) {
          return Stack(
            children: [
              GroupMap(members: state.members),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text(
                          _summary(state),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
