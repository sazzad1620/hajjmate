import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/utils/time_formatter.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_bloc.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_state.dart';

class ScreenAlerts extends StatelessWidget {
  const ScreenAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Alerts', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              const Expanded(child: _Body()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertListBloc, AlertListState>(
      builder: (context, state) {
        switch (state.status) {
          case AlertListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case AlertListStatus.failure:
            return Center(
              child: Text(state.message ?? 'Could not load alerts.'),
            );
          case AlertListStatus.ready:
            if (state.alerts.isEmpty) {
              return const Center(child: Text('No alerts yet'));
            }
            return ListView.separated(
              // Keeps the last tile above the floating bottom bar.
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: state.alerts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, index) => _AlertTile(alert: state.alerts[index]),
            );
        }
      },
    );
  }
}

class _AlertTile extends StatelessWidget {
  final Alert alert;

  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    final entered = alert.type == AlertType.enter;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          entered ? Icons.login_rounded : Icons.logout_rounded,
          color: entered ? null : Theme.of(context).colorScheme.error,
        ),
        title: Text(alert.summary),
        trailing: Text(TimeFormatter.ago(alert.timestamp)),
      ),
    );
  }
}
