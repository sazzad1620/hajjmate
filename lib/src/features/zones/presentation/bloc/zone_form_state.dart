import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

enum ZoneFormStatus { editing, submitting, success, failure }

class ZoneFormState extends Equatable {
  final Coordinates? centre;

  // Where the map opens: the phone's position, or the centre of the zone
  // being edited. Not the centre of a new zone.
  final Coordinates? startPosition;

  final Zone? editingZone;
  final double radiusM;
  final ZoneFormStatus status;
  final String? message;

  const ZoneFormState({
    this.centre,
    this.startPosition,
    this.editingZone,
    this.radiusM = AppConstants.defaultZoneRadiusM,
    this.status = ZoneFormStatus.editing,
    this.message,
  });

  ZoneFormState copyWith({
    Coordinates? centre,
    Coordinates? startPosition,
    Zone? editingZone,
    double? radiusM,
    ZoneFormStatus? status,
    String? message,
  }) {
    return ZoneFormState(
      centre: centre ?? this.centre,
      startPosition: startPosition ?? this.startPosition,
      editingZone: editingZone ?? this.editingZone,
      radiusM: radiusM ?? this.radiusM,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    centre,
    startPosition,
    editingZone,
    radiusM,
    status,
    message,
  ];
}
