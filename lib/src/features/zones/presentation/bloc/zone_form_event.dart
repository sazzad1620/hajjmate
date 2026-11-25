import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

abstract class ZoneFormEvent extends Equatable {
  const ZoneFormEvent();

  @override
  List<Object?> get props => [];
}

/// With a [zone] the form edits it, without one it creates a new zone.
class ZoneFormStarted extends ZoneFormEvent {
  final Zone? zone;

  const ZoneFormStarted({this.zone});

  @override
  List<Object?> get props => [zone];
}

class ZoneCentreSelected extends ZoneFormEvent {
  final Coordinates centre;

  const ZoneCentreSelected(this.centre);

  @override
  List<Object?> get props => [centre];
}

class ZoneRadiusChanged extends ZoneFormEvent {
  final double radiusM;

  const ZoneRadiusChanged(this.radiusM);

  @override
  List<Object?> get props => [radiusM];
}

class ZoneSubmitted extends ZoneFormEvent {
  final String name;

  const ZoneSubmitted(this.name);

  @override
  List<Object?> get props => [name];
}

class ZoneDeleted extends ZoneFormEvent {
  const ZoneDeleted();
}
