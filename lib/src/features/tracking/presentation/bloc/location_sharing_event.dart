import 'package:equatable/equatable.dart';

abstract class LocationSharingEvent extends Equatable {
  const LocationSharingEvent();

  @override
  List<Object?> get props => [];
}

class SharingStatusRequested extends LocationSharingEvent {
  const SharingStatusRequested();
}

class SharingStartRequested extends LocationSharingEvent {
  const SharingStartRequested();
}

class SharingStopRequested extends LocationSharingEvent {
  const SharingStopRequested();
}

class SharingLastSentReceived extends LocationSharingEvent {
  final DateTime sentAt;

  const SharingLastSentReceived(this.sentAt);

  @override
  List<Object?> get props => [sentAt];
}
