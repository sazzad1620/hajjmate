import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';

enum MapStatus { loading, ready, failure }

class GroupMapState extends Equatable {
  final MapStatus status;
  final List<LocationUpdate> members;
  final String? message;

  const GroupMapState({
    this.status = MapStatus.loading,
    this.members = const [],
    this.message,
  });

  @override
  List<Object?> get props => [status, members, message];
}
