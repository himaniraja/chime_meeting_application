import '../../domain/entities/meeting.dart';

class MeetingModel extends Meeting {
  const MeetingModel({
    required super.meetingId,
    required super.externalMeetingId,
    required super.mediaRegion,
    required super.mediaPlacement,
    required super.meetingFeatures,
    required super.tenantIds,
    required super.meetingArn,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      meetingId: json['MeetingId'] ?? '',
      externalMeetingId: json['ExternalMeetingId'] ?? '',
      mediaRegion: json['MediaRegion'] ?? '',
      mediaPlacement: MediaPlacementModel.fromJson(json['MediaPlacement'] ?? {}),
      meetingFeatures: MeetingFeaturesModel.fromJson(json['MeetingFeatures'] ?? {}),
      tenantIds: List<String>.from(json['TenantIds'] ?? []),
      meetingArn: json['MeetingArn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MeetingId': meetingId,
      'ExternalMeetingId': externalMeetingId,
      'MediaRegion': mediaRegion,
      'MediaPlacement': (mediaPlacement as MediaPlacementModel).toJson(),
      'MeetingFeatures': (meetingFeatures as MeetingFeaturesModel).toJson(),
      'TenantIds': tenantIds,
      'MeetingArn': meetingArn,
    };
  }
}

class MediaPlacementModel extends MediaPlacement {
  const MediaPlacementModel({
    required super.audioHostUrl,
    required super.audioFallbackUrl,
    required super.signalingUrl,
    required super.turnControlUrl,
    required super.screenDataUrl,
    required super.screenViewingUrl,
    required super.screenSharingUrl,
    required super.eventIngestionUrl,
  });

  factory MediaPlacementModel.fromJson(Map<String, dynamic> json) {
    return MediaPlacementModel(
      audioHostUrl: json['AudioHostUrl'] ?? '',
      audioFallbackUrl: json['AudioFallbackUrl'] ?? '',
      signalingUrl: json['SignalingUrl'] ?? '',
      turnControlUrl: json['TurnControlUrl'] ?? '',
      screenDataUrl: json['ScreenDataUrl'] ?? '',
      screenViewingUrl: json['ScreenViewingUrl'] ?? '',
      screenSharingUrl: json['ScreenSharingUrl'] ?? '',
      eventIngestionUrl: json['EventIngestionUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AudioHostUrl': audioHostUrl,
      'AudioFallbackUrl': audioFallbackUrl,
      'SignalingUrl': signalingUrl,
      'TurnControlUrl': turnControlUrl,
      'ScreenDataUrl': screenDataUrl,
      'ScreenViewingUrl': screenViewingUrl,
      'ScreenSharingUrl': screenSharingUrl,
      'EventIngestionUrl': eventIngestionUrl,
    };
  }
}

class MeetingFeaturesModel extends MeetingFeatures {
  const MeetingFeaturesModel({required AudioFeatureModel audio}) : super(audio: audio);

  factory MeetingFeaturesModel.fromJson(Map<String, dynamic> json) {
    return MeetingFeaturesModel(
      audio: AudioFeatureModel.fromJson(json['Audio'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Audio': (audio as AudioFeatureModel).toJson(),
    };
  }
}

class AudioFeatureModel extends AudioFeature {
  const AudioFeatureModel({required String echoReduction}) : super(echoReduction: echoReduction);

  factory AudioFeatureModel.fromJson(Map<String, dynamic> json) {
    return AudioFeatureModel(
      echoReduction: json['EchoReduction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EchoReduction': echoReduction,
    };
  }
}
