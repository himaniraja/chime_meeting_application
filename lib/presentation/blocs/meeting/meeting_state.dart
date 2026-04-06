import 'package:equatable/equatable.dart';
import '../../../domain/entities/meeting_session.dart';

abstract class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object?> get props => [];
}

class MeetingInitial extends MeetingState {}

class MeetingLoading extends MeetingState {}

class MeetingCreated extends MeetingState {
  final MeetingSession session;

  const MeetingCreated(this.session);

  @override
  List<Object?> get props => [session];
}

class MeetingJoined extends MeetingState {
  final MeetingSession session;

  const MeetingJoined(this.session);

  @override
  List<Object?> get props => [session];
}

class MeetingError extends MeetingState {
  final String message;

  const MeetingError(this.message);

  @override
  List<Object?> get props => [message];
}
