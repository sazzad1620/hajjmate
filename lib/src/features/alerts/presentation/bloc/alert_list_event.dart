import 'package:equatable/equatable.dart';

abstract class AlertListEvent extends Equatable {
  const AlertListEvent();

  @override
  List<Object?> get props => [];
}

class AlertListStarted extends AlertListEvent {
  const AlertListStarted();
}
