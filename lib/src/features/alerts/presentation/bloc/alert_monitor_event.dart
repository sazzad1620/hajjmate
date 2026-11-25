import 'package:equatable/equatable.dart';

abstract class AlertMonitorEvent extends Equatable {
  const AlertMonitorEvent();

  @override
  List<Object?> get props => [];
}

class AlertMonitorStarted extends AlertMonitorEvent {
  const AlertMonitorStarted();
}
