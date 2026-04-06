import 'package:equatable/equatable.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCallEvent extends VideoCallEvent {
  final String meetingId;
  final String attendeeId;
  final String joinToken;
  final String signalingUrl;
  final String audioHostUrl;

  const InitializeCallEvent({
    required this.meetingId,
    required this.attendeeId,
    required this.joinToken,
    required this.signalingUrl,
    required this.audioHostUrl,
  });

  @override
  List<Object?> get props => [meetingId, attendeeId, joinToken, signalingUrl, audioHostUrl];
}

class ToggleMicEvent extends VideoCallEvent {}

class ToggleCameraEvent extends VideoCallEvent {}

class ToggleScreenShareEvent extends VideoCallEvent {}

class EndCallEvent extends VideoCallEvent {}
