import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

enum ZoneFormStatus { editing, submitting, success, failure }

class ZoneFormState extends Equatable {
  final Coordinates? centre;

  /// Where the phone is now: the map opens here. Not the zone centre.
  final Coordinates? startPosition;
  final double radiusM;
  final ZoneFormStatus status;
  final String? message;

  const ZoneFormState({
    this.centre,
    this.startPosition,
    this.radiusM = AppConstants.defaultZoneRadiusM,
    this.status = ZoneFormStatus.editing,
    this.message,
  });

  ZoneFormState copyWith({
    Coordinates? centre,
    Coordinates? startPosition,
    double? radiusM,
    ZoneFormStatus? status,
    String? message,
  }) {
    return ZoneFormState(
      centre: centre ?? this.centre,
      startPosition: startPosition ?? this.startPosition,
      radiusM: radiusM ?? this.radiusM,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [centre, startPosition, radiusM, status, message];
}
