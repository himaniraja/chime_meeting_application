import 'package:equatable/equatable.dart';

class Attendee extends Equatable {
  final String externalUserId;
  final String attendeeId;
  final String joinToken;
  final AttendeeCapabilities capabilities;

  const Attendee({
    required this.externalUserId,
    required this.attendeeId,
    required this.joinToken,
    required this.capabilities,
  });

  @override
  List<Object?> get props => [attendeeId, joinToken];
}

class AttendeeCapabilities extends Equatable {
  final String audio;
  final String video;
  final String content;

  const AttendeeCapabilities({
    required this.audio,
    required this.video,
    required this.content,
  });

  @override
  List<Object?> get props => [audio, video, content];
}
