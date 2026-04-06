import 'package:flutter_bloc/flutter_bloc.dart';
import 'video_call_event.dart';
import 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  VideoCallBloc() : super(VideoCallInitial()) {
    on<InitializeCallEvent>(_onInitializeCall);
    on<ToggleMicEvent>(_onToggleMic);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<ToggleScreenShareEvent>(_onToggleScreenShare);
    on<EndCallEvent>(_onEndCall);
  }

  void _onInitializeCall(
    InitializeCallEvent event,
    Emitter<VideoCallState> emit,
  ) {
    emit(VideoCallConnecting());
    emit(const VideoCallConnected());
  }

  void _onToggleMic(
    ToggleMicEvent event,
    Emitter<VideoCallState> emit,
  ) {
    if (state is VideoCallConnected) {
      final currentState = state as VideoCallConnected;
      emit(currentState.copyWith(isMicOn: !currentState.isMicOn));
    }
  }

  void _onToggleCamera(
    ToggleCameraEvent event,
    Emitter<VideoCallState> emit,
  ) {
    if (state is VideoCallConnected) {
      final currentState = state as VideoCallConnected;
      emit(currentState.copyWith(isCameraOn: !currentState.isCameraOn));
    }
  }

  void _onToggleScreenShare(
    ToggleScreenShareEvent event,
    Emitter<VideoCallState> emit,
  ) {
    if (state is VideoCallConnected) {
      final currentState = state as VideoCallConnected;
      emit(currentState.copyWith(isScreenSharing: !currentState.isScreenSharing));
    }
  }

  void _onEndCall(
    EndCallEvent event,
    Emitter<VideoCallState> emit,
  ) {
    emit(VideoCallDisconnected());
  }
}
