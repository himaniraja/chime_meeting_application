import 'package:equatable/equatable.dart';

class Meeting extends Equatable {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;
  final MeetingFeatures meetingFeatures;
  final List<String> tenantIds;
  final String meetingArn;

  const Meeting({
    required this.meetingId,
    required this.externalMeetingId,
    required this.mediaRegion,
    required this.mediaPlacement,
    required this.meetingFeatures,
    required this.tenantIds,
    required this.meetingArn,
  });

  @override
  List<Object?> get props => [meetingId, externalMeetingId, mediaRegion];
}

class MediaPlacement extends Equatable {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControlUrl;
  final String screenDataUrl;
  final String screenViewingUrl;
  final String screenSharingUrl;
  final String eventIngestionUrl;

  const MediaPlacement({
    required this.audioHostUrl,
    required this.audioFallbackUrl,
    required this.signalingUrl,
    required this.turnControlUrl,
    required this.screenDataUrl,
    required this.screenViewingUrl,
    required this.screenSharingUrl,
    required this.eventIngestionUrl,
  });

  @override
  List<Object?> get props => [audioHostUrl, signalingUrl];
}

class MeetingFeatures extends Equatable {
  final AudioFeature audio;

  const MeetingFeatures({required this.audio});

  @override
  List<Object?> get props => [audio];
}

class AudioFeature extends Equatable {
  final String echoReduction;

  const AudioFeature({required this.echoReduction});

  @override
  List<Object?> get props => [echoReduction];
}
