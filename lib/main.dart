import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'di/injection_container.dart' as di;
import 'data/models/meeting_session_model.dart';
import 'presentation/screens/video_call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await di.init();
  runApp(const ChimeMeetingApp());
}

class DeepLinkHandler {
  static Future<Route<dynamic>?> handleUri(Uri uri) async {
    if (uri.scheme == 'himani' && uri.host == 'join') {
      final data = uri.queryParameters['data'];
      if (data != null) {
        try {
          final decodedData = Uri.decodeComponent(data);
          final session = MeetingSessionModel.fromJsonString(decodedData);
          return MaterialPageRoute(
            builder: (_) => VideoCallScreen(session: session),
          );
        } catch (e) {
          debugPrint('Failed to parse deep link: $e');
        }
      }
    }
    return null;
  }
}
