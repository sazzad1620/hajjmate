import 'package:equatable/equatable.dart';

abstract class OwnPositionEvent extends Equatable {
  const OwnPositionEvent();

  @override
  List<Object?> get props => [];
}

class OwnPositionStarted extends OwnPositionEvent {
  const OwnPositionStarted();
}
