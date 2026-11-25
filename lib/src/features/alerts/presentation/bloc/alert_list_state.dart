import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';

enum AlertListStatus { loading, ready, failure }

class AlertListState extends Equatable {
  final AlertListStatus status;
  final List<Alert> alerts;
  final String? message;

  const AlertListState({
    this.status = AlertListStatus.loading,
    this.alerts = const [],
    this.message,
  });

  @override
  List<Object?> get props => [status, alerts, message];
}
