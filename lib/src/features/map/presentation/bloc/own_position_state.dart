import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class OwnPositionState extends Equatable {
  // Null until the phone knows where it is, or when location is not allowed.
  final Coordinates? position;

  const OwnPositionState({this.position});

  @override
  List<Object?> get props => [position];
}
