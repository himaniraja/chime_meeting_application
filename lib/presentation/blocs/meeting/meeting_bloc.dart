import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/meeting_usecases.dart';
import 'meeting_event.dart';
import 'meeting_state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final CreateMeetingUseCase createMeetingUseCase;
  final JoinMeetingUseCase joinMeetingUseCase;
  final RejoinMeetingUseCase rejoinMeetingUseCase;

  MeetingBloc({
    required this.createMeetingUseCase,
    required this.joinMeetingUseCase,
    required this.rejoinMeetingUseCase,
  }) : super(MeetingInitial()) {
    on<CreateMeetingEvent>(_onCreateMeeting);
    on<JoinMeetingEvent>(_onJoinMeeting);
    on<RejoinMeetingEvent>(_onRejoinMeeting);
    on<ResetMeetingEvent>(_onResetMeeting);
  }

  Future<void> _onCreateMeeting(
    CreateMeetingEvent event,
    Emitter<MeetingState> emit,
  ) async {
    emit(MeetingLoading());
    try {
      final session = await createMeetingUseCase();
      emit(MeetingCreated(session));
    } on Failure catch (e) {
      emit(MeetingError(e.message));
    } catch (e) {
      emit(MeetingError(e.toString()));
    }
  }

  Future<void> _onJoinMeeting(
    JoinMeetingEvent event,
    Emitter<MeetingState> emit,
  ) async {
    emit(MeetingLoading());
    try {
      final session = await joinMeetingUseCase(event.externalMeetingId);
      emit(MeetingJoined(session));
    } on Failure catch (e) {
      emit(MeetingError(e.message));
    } catch (e) {
      emit(MeetingError(e.toString()));
    }
  }

  Future<void> _onRejoinMeeting(
    RejoinMeetingEvent event,
    Emitter<MeetingState> emit,
  ) async {
    emit(MeetingLoading());
    try {
      final session = await rejoinMeetingUseCase(event.externalMeetingId);
      emit(MeetingJoined(session));
    } on Failure catch (e) {
      emit(MeetingError(e.message));
    } catch (e) {
      emit(MeetingError(e.toString()));
    }
  }

  void _onResetMeeting(
    ResetMeetingEvent event,
    Emitter<MeetingState> emit,
  ) {
    emit(MeetingInitial());
  }
}
