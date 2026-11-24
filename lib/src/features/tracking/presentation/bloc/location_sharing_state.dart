import 'package:equatable/equatable.dart';

enum SharingStatus { off, starting, on, failure }

class LocationSharingState extends Equatable {
  final SharingStatus status;
  final DateTime? lastSentAt;
  final String? message;

  const LocationSharingState({
    this.status = SharingStatus.off,
    this.lastSentAt,
    this.message,
  });

  /// `message` is replaced on every copy, so an old error never lingers.
  LocationSharingState copyWith({
    SharingStatus? status,
    DateTime? lastSentAt,
    String? message,
  }) {
    return LocationSharingState(
      status: status ?? this.status,
      lastSentAt: lastSentAt ?? this.lastSentAt,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, lastSentAt, message];
}
