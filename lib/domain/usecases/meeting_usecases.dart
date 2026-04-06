import '../entities/meeting_session.dart';
import '../repositories/meeting_repository.dart';

class CreateMeetingUseCase {
  final MeetingRepository repository;

  CreateMeetingUseCase(this.repository);

  Future<MeetingSession> call() async {
    return await repository.createMeeting();
  }
}

class JoinMeetingUseCase {
  final MeetingRepository repository;

  JoinMeetingUseCase(this.repository);

  Future<MeetingSession> call(String externalMeetingId) async {
    return await repository.joinAsClient(externalMeetingId);
  }
}

class RejoinMeetingUseCase {
  final MeetingRepository repository;

  RejoinMeetingUseCase(this.repository);

  Future<MeetingSession> call(String externalMeetingId) async {
    return await repository.rejoinAsAgent(externalMeetingId);
  }
}
