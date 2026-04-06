import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/meeting_session.dart';
import '../../domain/repositories/meeting_repository.dart';
import '../datasources/meeting_remote_datasource.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingRemoteDataSource remoteDataSource;

  MeetingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MeetingSession> createMeeting() async {
    try {
      return await remoteDataSource.createMeeting();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<MeetingSession> joinAsClient(String externalMeetingId) async {
    try {
      return await remoteDataSource.joinAsClient(externalMeetingId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<MeetingSession> rejoinAsAgent(String externalMeetingId) async {
    try {
      return await remoteDataSource.rejoinAsAgent(externalMeetingId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
