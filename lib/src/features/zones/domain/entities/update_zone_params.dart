import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';

// The centre never changes: only the name and radius can be edited.
class UpdateZoneParams extends Equatable {
  final Zone zone;
  final String name;
  final double radiusM;

  const UpdateZoneParams({
    required this.zone,
    required this.name,
    required this.radiusM,
  });

  @override
  List<Object?> get props => [zone, name, radiusM];
}
