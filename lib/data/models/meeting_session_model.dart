import 'dart:convert';
import '../../domain/entities/meeting_session.dart';
import 'meeting_model.dart';
import 'attendee_model.dart';

class MeetingSessionModel extends MeetingSession {
  const MeetingSessionModel({
    required MeetingModel meeting,
    required AttendeeModel attendee,
  }) : super(meeting: meeting, attendee: attendee);

  factory MeetingSessionModel.fromJson(Map<String, dynamic> json) {
    return MeetingSessionModel(
      meeting: MeetingModel.fromJson(json['meeting'] ?? {}),
      attendee: AttendeeModel.fromJson(json['attendee'] ?? {}),
    );
  }

  factory MeetingSessionModel.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return MeetingSessionModel.fromJson(json);
  }

  String toShareableJson() {
    return jsonEncode({
      'meeting': (meeting as MeetingModel).toJson(),
      'attendee': (attendee as AttendeeModel).toJson(),
    });
  }
}
