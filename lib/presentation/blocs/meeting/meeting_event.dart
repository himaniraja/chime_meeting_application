import 'package:equatable/equatable.dart';

abstract class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object?> get props => [];
}

class CreateMeetingEvent extends MeetingEvent {}

class JoinMeetingEvent extends MeetingEvent {
  final String externalMeetingId;

  const JoinMeetingEvent(this.externalMeetingId);

  @override
  List<Object?> get props => [externalMeetingId];
}

class RejoinMeetingEvent extends MeetingEvent {
  final String externalMeetingId;

  const RejoinMeetingEvent(this.externalMeetingId);

  @override
  List<Object?> get props => [externalMeetingId];
}

class ResetMeetingEvent extends MeetingEvent {}
