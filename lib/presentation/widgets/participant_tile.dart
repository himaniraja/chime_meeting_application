import 'package:flutter/material.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 120,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Waiting for others to join...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
