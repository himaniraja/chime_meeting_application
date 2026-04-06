import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aws_chime/views/meeting.view.dart';
import 'package:flutter_aws_chime/models/join_info.model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/meeting_session.dart';

class VideoCallScreen extends StatefulWidget {
  final MeetingSession session;

  const VideoCallScreen({super.key, required this.session});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late MeetingSession session;
  bool _isInitializing = true;
  bool _hasConnectionError = false;
  String _logMessages = '';
  List<Permission> _requestedPermissions = [];
  Map<Permission, PermissionStatus> _permissionStatuses = {};

  @override
  void initState() {
    super.initState();
    session = widget.session;
    _checkMeetingData();
    _initializePermissions();
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    setState(() {
      _logMessages += '[$timestamp] $message\n';
    });
    debugPrint('[VideoCall] $message');
  }

  void _checkMeetingData() {
    _addLog('Checking meeting data...');
    _addLog('Meeting ID: ${session.meeting.meetingId}');
    _addLog('Signaling URL: "${session.meeting.mediaPlacement.signalingUrl}"');
    _addLog('Audio Host URL: "${session.meeting.mediaPlacement.audioHostUrl}"');

    if (session.meeting.mediaPlacement.signalingUrl.isEmpty) {
      _addLog('ERROR: Signaling URL is EMPTY!');
      setState(() {
        _hasConnectionError = true;
      });
    }
  }

  Future<void> _initializePermissions() async {
    _addLog('Starting permission initialization...');

    _addLog('Checking camera permission status...');
    final cameraStatus = await Permission.camera.status;
    _addLog('Camera status: $cameraStatus');

    _addLog('Checking microphone permission status...');
    final micStatus = await Permission.microphone.status;
    _addLog('Microphone status: $micStatus');

    _addLog('Requesting permissions...');
    _requestedPermissions = [Permission.camera, Permission.microphone];
    final results = await _requestedPermissions.request();
    _permissionStatuses = results;

    for (var entry in results.entries) {
      _addLog('${entry.key}: ${entry.value}');
    }

    final cameraGranted = results[Permission.camera]?.isGranted ?? false;
    final micGranted = results[Permission.microphone]?.isGranted ?? false;

    _addLog('Camera granted: $cameraGranted, Mic granted: $micGranted');

    setState(() {
      _isInitializing = false;
    });
  }

  void _showLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Logs'),
        content: SingleChildScrollView(
          child: SelectableText(
            _logMessages,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _logMessages));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logs copied!')),
              );
            },
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Initializing...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please grant camera and microphone permissions',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showLogs,
                icon: const Icon(Icons.bug_report),
                label: const Text('Show Logs'),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasConnectionError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Connection Error',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Backend API Issue:',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Client join API only returns MeetingId.\n'
                        'Missing MediaPlacement (SignalingUrl, AudioHostUrl).\n\n'
                        'Fix needed in backend API.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Share these logs with the backend team:',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showLogs,
                  icon: const Icon(Icons.copy),
                  label: const Text('View & Copy Logs'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    _addLog('Building MeetingView...');

    final mediaPlacement = MediaPlacement(
      session.meeting.mediaPlacement.audioHostUrl,
      session.meeting.mediaPlacement.audioFallbackUrl,
      session.meeting.mediaPlacement.signalingUrl,
      session.meeting.mediaPlacement.turnControlUrl,
    );

    final meetingInfo = MeetingInfo(
      session.meeting.meetingId,
      session.meeting.externalMeetingId,
      session.meeting.mediaRegion,
      mediaPlacement,
    );

    final attendeeInfo = AttendeeInfo(
      session.attendee.externalUserId,
      session.attendee.attendeeId,
      session.attendee.joinToken,
    );

    final joinInfo = JoinInfo(meetingInfo, attendeeInfo);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            MeetingView(
              joinInfo,
              onLeave: (didLeave) {
                _addLog('onLeave called with didLeave: $didLeave');
                if (didLeave) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
            ),
            Positioned(
              top: 60,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: _showLogs,
                icon: const Icon(Icons.bug_report, size: 16),
                label: const Text('Logs', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Camera: ${_permissionStatuses[Permission.camera]?.isGranted == true ? "OK" : "Denied"}',
                      style: TextStyle(
                        color:
                            _permissionStatuses[Permission.camera]?.isGranted ==
                                    true
                                ? Colors.green
                                : Colors.red,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Mic: ${_permissionStatuses[Permission.microphone]?.isGranted == true ? "OK" : "Denied"}',
                      style: TextStyle(
                        color: _permissionStatuses[Permission.microphone]
                                    ?.isGranted ==
                                true
                            ? Colors.green
                            : Colors.red,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
