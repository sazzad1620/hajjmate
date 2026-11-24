import 'package:equatable/equatable.dart';

abstract class GroupMapEvent extends Equatable {
  const GroupMapEvent();

  @override
  List<Object?> get props => [];
}

class GroupMapStarted extends GroupMapEvent {
  const GroupMapStarted();
}
