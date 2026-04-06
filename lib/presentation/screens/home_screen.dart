import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/meeting/meeting_bloc.dart';
import '../blocs/meeting/meeting_event.dart';
import '../blocs/meeting/meeting_state.dart';
import 'join_meeting_screen.dart';
import 'waiting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chime Meeting'),
      ),
      body: BlocListener<MeetingBloc, MeetingState>(
        listener: (context, state) {
          if (state is MeetingCreated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => WaitingScreen(session: state.session),
              ),
            );
          } else if (state is MeetingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.video_call,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 48),
                const Text(
                  'Video Meeting App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with others via video call',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<MeetingBloc, MeetingState>(
                    builder: (context, state) {
                      return ElevatedButton.icon(
                        onPressed: state is MeetingLoading
                            ? null
                            : () {
                                context.read<MeetingBloc>().add(CreateMeetingEvent());
                              },
                        icon: state is MeetingLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.add),
                        label: Text(state is MeetingLoading ? 'Creating...' : 'Create Meeting'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JoinMeetingScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Join Meeting'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
