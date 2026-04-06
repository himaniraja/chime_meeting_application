import 'package:equatable/equatable.dart';
import 'meeting.dart';
import 'attendee.dart';

class MeetingSession extends Equatable {
  final Meeting meeting;
  final Attendee attendee;

  const MeetingSession({
    required this.meeting,
    required this.attendee,
  });

  @override
  List<Object?> get props => [meeting, attendee];
}
