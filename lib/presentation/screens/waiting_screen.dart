import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/models/meeting_session_model.dart';
import '../../domain/entities/meeting_session.dart';
import 'video_call_screen.dart';

class WaitingScreen extends StatelessWidget {
  final MeetingSession session;

  const WaitingScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final meetingId = session.meeting.meetingId;
    final shortCode = session.meeting.externalMeetingId;
    final sessionModel = session as MeetingSessionModel;
    final shareableData = sessionModel.toShareableJson();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Room'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'Meeting Created!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share with the client to join',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: shareableData,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Scan to Join',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Meeting ID: ${meetingId.substring(0, 8)}...',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Other Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: shareableData));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Full meeting data copied!')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Meeting Data'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: meetingId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Meeting ID copied!')),
                    );
                  },
                  icon: const Icon(Icons.key),
                  label: Text('Copy Meeting ID ($shortCode)'),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoCallScreen(session: session),
                      ),
                    );
                  },
                  icon: const Icon(Icons.videocam),
                  label: const Text('Join Meeting'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
