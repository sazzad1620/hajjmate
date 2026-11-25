import 'package:equatable/equatable.dart';

enum AlertMonitorStatus { starting, on, failure }

class AlertMonitorState extends Equatable {
  final AlertMonitorStatus status;

  const AlertMonitorState({this.status = AlertMonitorStatus.starting});

  @override
  List<Object?> get props => [status];
}
