import 'package:equatable/equatable.dart';

abstract class ZoneListEvent extends Equatable {
  const ZoneListEvent();

  @override
  List<Object?> get props => [];
}

class ZoneListStarted extends ZoneListEvent {
  const ZoneListStarted();
}
