import '../../domain/entities/attendee.dart';

class AttendeeModel extends Attendee {
  const AttendeeModel({
    required super.externalUserId,
    required super.attendeeId,
    required super.joinToken,
    required super.capabilities,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    return AttendeeModel(
      externalUserId: json['ExternalUserId'] ?? '',
      attendeeId: json['AttendeeId'] ?? '',
      joinToken: json['JoinToken'] ?? '',
      capabilities: AttendeeCapabilitiesModel.fromJson(json['Capabilities'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ExternalUserId': externalUserId,
      'AttendeeId': attendeeId,
      'JoinToken': joinToken,
      'Capabilities': (capabilities as AttendeeCapabilitiesModel).toJson(),
    };
  }
}

class AttendeeCapabilitiesModel extends AttendeeCapabilities {
  const AttendeeCapabilitiesModel({
    required super.audio,
    required super.video,
    required super.content,
  });

  factory AttendeeCapabilitiesModel.fromJson(Map<String, dynamic> json) {
    return AttendeeCapabilitiesModel(
      audio: json['Audio'] ?? '',
      video: json['Video'] ?? '',
      content: json['Content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Audio': audio,
      'Video': video,
      'Content': content,
    };
  }
}
