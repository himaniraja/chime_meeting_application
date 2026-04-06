import '../entities/meeting_session.dart';

abstract class MeetingRepository {
  Future<MeetingSession> createMeeting();
  Future<MeetingSession> joinAsClient(String meetingId);
  Future<MeetingSession> rejoinAsAgent(String meetingId);
}
