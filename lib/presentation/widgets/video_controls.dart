import 'package:flutter/material.dart';

class VideoControls extends StatelessWidget {
  final bool isMicOn;
  final bool isCameraOn;
  final bool isScreenSharing;
  final VoidCallback onMicToggle;
  final VoidCallback onCameraToggle;
  final VoidCallback onScreenShareToggle;
  final VoidCallback onEndCall;

  const VideoControls({
    super.key,
    required this.isMicOn,
    required this.isCameraOn,
    required this.isScreenSharing,
    required this.onMicToggle,
    required this.onCameraToggle,
    required this.onScreenShareToggle,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: isMicOn ? Icons.mic : Icons.mic_off,
            label: isMicOn ? 'Mute' : 'Unmute',
            isActive: isMicOn,
            onTap: onMicToggle,
          ),
          _ControlButton(
            icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
            label: isCameraOn ? 'Camera' : 'Camera Off',
            isActive: isCameraOn,
            onTap: onCameraToggle,
          ),
          _ControlButton(
            icon: isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
            label: isScreenSharing ? 'Stop' : 'Share',
            isActive: isScreenSharing,
            onTap: onScreenShareToggle,
          ),
          _ControlButton(
            icon: Icons.call_end,
            label: 'End',
            isEndCall: true,
            onTap: onEndCall,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isEndCall;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.isActive = true,
    this.isEndCall = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isEndCall
                  ? Colors.red
                  : isActive
                      ? Colors.grey.shade700
                      : Colors.red.shade400,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
