import 'package:electocracy/app/models/poll.dart';
import 'package:flutter/material.dart';

class PollView extends StatelessWidget {
  final Poll poll;

  const PollView({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Puntos Clave',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(poll.summary),
            const SizedBox(height: 20.0),
            const Text(
              'Contenido',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(poll.content),
          ],
        ),
      ),
    );
  }
}
