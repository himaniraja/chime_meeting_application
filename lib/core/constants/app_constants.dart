import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String apiKey = dotenv.env['API_KEY'] ?? '';
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
}

class MeetingType {
  static const String agent = 'agent';
  static const String client = 'client';
}
