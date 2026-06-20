import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/meeting_session_model.dart';

abstract class MeetingRemoteDataSource {
  Future<MeetingSessionModel> createMeeting();
  Future<MeetingSessionModel> joinAsClient(String meetingId);
  Future<MeetingSessionModel> rejoinAsAgent(String meetingId);
}

class MeetingRemoteDataSourceImpl implements MeetingRemoteDataSource {
  final Dio dio;

  MeetingRemoteDataSourceImpl({required this.dio});

  @override
  Future<MeetingSessionModel> createMeeting() async {
    try {
      final response = await dio.post(
        '/api/meetings',
        queryParameters: {'type': MeetingType.agent},
        options: Options(
          headers: {'x-api-key': AppConstants.apiKey},
        ),
      );

      debugPrint('[API_CREATE] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return MeetingSessionModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Failed to create meeting');
      }
    } on DioException catch (e) {
      debugPrint('[API_CREATE] DioException: ${e.type}');
      debugPrint('[API_CREATE] Message: ${e.message}');
      debugPrint('[API_CREATE] Response: ${e.response?.data}');
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<MeetingSessionModel> joinAsClient(String meetingId) async {
    try {
      debugPrint('[API_CLIENT] Joining as client...');
      debugPrint('[API_CLIENT] Meeting ID being used: $meetingId');

      final response = await dio.post(
        '/api/meetings',
        queryParameters: {
          'type': MeetingType.client,
          'meeting_id': meetingId,
        },
        options: Options(
          headers: {'x-api-key': AppConstants.apiKey},
        ),
      );

      debugPrint('[API_CLIENT] Response status: ${response.statusCode}');
      debugPrint('[API_CLIENT] Full response: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final session = MeetingSessionModel.fromJson(response.data['data']);
        debugPrint('[API_CLIENT] Parsed meeting ID: ${session.meeting.meetingId}');
        debugPrint(
            '[API_CLIENT] Signaling URL: "${session.meeting.mediaPlacement.signalingUrl}"');
        debugPrint(
            '[API_CLIENT] Audio Host URL: "${session.meeting.mediaPlacement.audioHostUrl}"');

        if (session.meeting.mediaPlacement.signalingUrl.isEmpty) {
          debugPrint('[API_CLIENT] WARNING: Signaling URL is EMPTY!');
        }

        return session;
      } else {
        throw ServerException(
            response.data['message'] ?? 'Failed to join meeting');
      }
    } on DioException catch (e) {
      debugPrint('[API_CLIENT] DioException: ${e.type}');
      debugPrint('[API_CLIENT] Message: ${e.message}');
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<MeetingSessionModel> rejoinAsAgent(String meetingId) async {
    try {
      debugPrint(
          '[API_AGENT_REJOIN] Rejoining as agent with meeting_id: $meetingId');

      final response = await dio.post(
        '/api/meetings',
        queryParameters: {
          'type': MeetingType.agent,
          'meeting_id': meetingId,
        },
        options: Options(
          headers: {'x-api-key': AppConstants.apiKey},
        ),
      );

      debugPrint('[API_AGENT_REJOIN] Response: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return MeetingSessionModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Failed to rejoin meeting');
      }
    } on DioException catch (e) {
      debugPrint('[API_AGENT_REJOIN] DioException: ${e.type}');
      debugPrint('[API_AGENT_REJOIN] Message: ${e.message}');
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
