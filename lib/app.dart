import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart' as di;
import 'presentation/blocs/meeting/meeting_bloc.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/video_call_screen.dart';
import 'data/models/meeting_session_model.dart';

class ChimeMeetingApp extends StatefulWidget {
  const ChimeMeetingApp({super.key});

  @override
  State<ChimeMeetingApp> createState() => _ChimeMeetingAppState();
}

class _ChimeMeetingAppState extends State<ChimeMeetingApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForDeepLink();
    }
  }

  Future<void> _checkForDeepLink() async {
    // This will be handled by the native side
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MeetingBloc>(),
      child: MaterialApp(
        title: 'Chime Meeting',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          final uri = Uri.tryParse(settings.name ?? '');
          if (uri != null && uri.scheme == 'himani' && uri.host == 'join') {
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
        },
      ),
    );
  }
}
