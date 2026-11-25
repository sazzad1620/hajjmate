import 'package:equatable/equatable.dart';

class DeleteZoneParams extends Equatable {
  final String zoneId;

  const DeleteZoneParams({required this.zoneId});

  @override
  List<Object?> get props => [zoneId];
}
