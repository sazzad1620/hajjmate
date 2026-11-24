import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';

enum ZoneListStatus { loading, ready, failure }

class ZoneListState extends Equatable {
  final ZoneListStatus status;
  final List<Zone> zones;
  final String? message;

  const ZoneListState({
    this.status = ZoneListStatus.loading,
    this.zones = const [],
    this.message,
  });

  @override
  List<Object?> get props => [status, zones, message];
}
