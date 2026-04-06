import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/models/meeting_session_model.dart';
import '../../data/models/meeting_model.dart';
import '../../data/models/attendee_model.dart';
import 'video_call_screen.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _meetingDataController = TextEditingController();
  bool _isLoading = false;
  bool _hasCameraPermission = false;
  int _selectedTab = 0;
  MobileScannerController? _scannerController;

  @override
  void dispose() {
    _meetingDataController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _hasCameraPermission = true;
        _scannerController = MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        );
      });
    } else {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {
          _hasCameraPermission = true;
          _scannerController = MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
            facing: CameraFacing.back,
            torchEnabled: false,
          );
        });
      } else {
        setState(() => _hasCameraPermission = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.meeting_room,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              const Text(
                'Join Meeting',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('Paste Data'),
                    icon: Icon(Icons.paste),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('Scan QR'),
                    icon: Icon(Icons.qr_code_scanner),
                  ),
                ],
                selected: {_selectedTab},
                onSelectionChanged: (selected) {
                  if (selected.first == 1 && !_hasCameraPermission) {
                    _checkCameraPermission();
                  }
                  setState(() => _selectedTab = selected.first);
                },
              ),
              const SizedBox(height: 24),
              if (_selectedTab == 0) _buildPasteMode() else _buildScanMode(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'You will join as a CLIENT.\nThe host will see you in their meeting.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasteMode() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: const Text(
            'Ask the host to share the full meeting data (QR code or JSON).\n'
            'The host can tap "Copy Meeting Data" on their Waiting screen.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF1976D2),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _meetingDataController,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Full Meeting Data (JSON)',
            hintText: 'Paste the JSON data from host',
            prefixIcon: Icon(Icons.data_object),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please paste meeting data';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ElevatedButton(
            onPressed: _handleJoin,
            child: const Text('Join Meeting'),
          ),
      ],
    );
  }

  Widget _buildScanMode() {
    if (!_hasCameraPermission) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.camera_alt, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Camera permission is required to scan QR codes.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _checkCameraPermission,
            icon: const Icon(Icons.settings),
            label: const Text('Grant Camera Permission'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => setState(() => _selectedTab = 0),
            icon: const Icon(Icons.paste),
            label: const Text('Use Paste Mode Instead'),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: const Text(
            'Point your camera at the QR code displayed on the host\'s waiting screen.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF1976D2),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.hardEdge,
          child: MobileScanner(
            key: ValueKey('scanner_$_hasCameraPermission'),
            controller: _scannerController ??= MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
              torchEnabled: false,
            ),
            onDetect: (capture) {
              debugPrint(
                  'QR Scanner detected: ${capture.barcodes.length} barcodes');
              if (_isLoading) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode value: ${barcode.rawValue}');
                debugPrint('Barcode format: ${barcode.format}');
                if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                  _meetingDataController.text = barcode.rawValue!;
                  debugPrint('QR code scanned successfully, joining...');
                  _handleJoin(fromQrScanner: true);
                  break;
                }
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                _scannerController?.toggleTorch();
              },
              icon: const Icon(Icons.flash_on),
              label: const Text('Torch'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                _scannerController?.switchCamera();
              },
              icon: const Icon(Icons.cameraswitch),
              label: const Text('Switch'),
            ),
            OutlinedButton.icon(
              onPressed: () => setState(() => _selectedTab = 0),
              icon: const Icon(Icons.paste),
              label: const Text('Paste'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleJoin({bool fromQrScanner = false}) async {
    if (!fromQrScanner && !_formKey.currentState!.validate()) return;

    if (fromQrScanner) {
      setState(() => _isLoading = true);
    } else {
      setState(() => _isLoading = true);
    }

    try {
      await _joinWithPasteData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _joinWithPasteData() async {
    final input = _meetingDataController.text.trim();

    try {
      final jsonData = jsonDecode(input) as Map<String, dynamic>;

      final meetingJson = jsonData['meeting'] as Map<String, dynamic>;
      final originalAttendeeJson = jsonData['attendee'] as Map<String, dynamic>;

      final meetingId = meetingJson['MeetingId'] as String;

      debugPrint('Extracted MeetingId: $meetingId');
      debugPrint(
          'Original ExternalUserId: ${originalAttendeeJson['ExternalUserId']}');

      final meeting = MeetingModel.fromJson(meetingJson);

      final apiKey = dotenv.env['API_KEY'] ?? '';
      final baseUrl = dotenv.env['BASE_URL'] ?? '';

      final dio = Dio(BaseOptions(baseUrl: baseUrl));

      final response = await dio.post(
        '/api/meetings',
        queryParameters: {
          'type': 'client',
          'meeting_id': meetingId,
        },
        options: Options(
          headers: {'x-api-key': apiKey},
        ),
      );

      debugPrint('API Response: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final clientAttendeeData =
            response.data['data']['attendee'] as Map<String, dynamic>;

        final attendee = AttendeeModel(
          externalUserId: clientAttendeeData['ExternalUserId'] as String,
          attendeeId: clientAttendeeData['AttendeeId'] as String,
          joinToken: clientAttendeeData['JoinToken'] as String,
          capabilities: AttendeeCapabilitiesModel(
            audio: clientAttendeeData['Capabilities']?['Audio'] as String? ??
                'SendReceive',
            video: clientAttendeeData['Capabilities']?['Video'] as String? ??
                'SendReceive',
            content:
                clientAttendeeData['Capabilities']?['Content'] as String? ??
                    'SendReceive',
          ),
        );

        final session = MeetingSessionModel(
          meeting: meeting,
          attendee: attendee,
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VideoCallScreen(session: session),
            ),
          );
        }
      } else {
        throw Exception(response.data['message'] ?? 'Failed to join meeting');
      }
    } catch (e) {
      debugPrint('Join error: $e');
      rethrow;
    }
  }
}
