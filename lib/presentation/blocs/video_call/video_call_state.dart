import 'package:equatable/equatable.dart';

abstract class VideoCallState extends Equatable {
  const VideoCallState();

  @override
  List<Object?> get props => [];
}

class VideoCallInitial extends VideoCallState {}

class VideoCallConnecting extends VideoCallState {}

class VideoCallConnected extends VideoCallState {
  final bool isMicOn;
  final bool isCameraOn;
  final bool isScreenSharing;

  const VideoCallConnected({
    this.isMicOn = true,
    this.isCameraOn = true,
    this.isScreenSharing = false,
  });

  VideoCallConnected copyWith({
    bool? isMicOn,
    bool? isCameraOn,
    bool? isScreenSharing,
  }) {
    return VideoCallConnected(
      isMicOn: isMicOn ?? this.isMicOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
    );
  }

  @override
  List<Object?> get props => [isMicOn, isCameraOn, isScreenSharing];
}

class VideoCallDisconnected extends VideoCallState {}

class VideoCallError extends VideoCallState {
  final String message;

  const VideoCallError(this.message);

  @override
  List<Object?> get props => [message];
}
