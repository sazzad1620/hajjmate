import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/config/router/app_routes.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_state.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';

class ScreenZones extends StatelessWidget {
  const ScreenZones({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: BlocBuilder<ZoneListBloc, ZoneListState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Zones', style: textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${state.zones.length} of ${AppConstants.maxZonesPerGroup}',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _Body(state: state)),
                  BaseButton(
                    label: 'Add zone',
                    onPressed: () => context.push(AppRoutes.zoneForm),
                  ),
                  // Keeps the button above the floating bottom bar.
                  const SizedBox(height: 96),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ZoneListState state;

  const _Body({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case ZoneListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ZoneListStatus.failure:
        return Center(child: Text(state.message ?? 'Could not load zones.'));
      case ZoneListStatus.ready:
        if (state.zones.isEmpty) {
          return const Center(child: Text('No zones yet'));
        }
        return ListView.separated(
          itemCount: state.zones.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, index) => _ZoneTile(zone: state.zones[index]),
        );
    }
  }
}

class _ZoneTile extends StatelessWidget {
  final Zone zone;

  const _ZoneTile({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.pin_drop_rounded),
        title: Text(zone.name),
        trailing: Text('${zone.radiusM.round()} m'),
      ),
    );
  }
}
