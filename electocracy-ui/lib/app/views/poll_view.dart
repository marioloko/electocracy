import 'package:electocracy/app/constants/language.dart';
import 'package:electocracy/app/models/poll.dart';
import 'package:flutter/material.dart';

class PollViewArguments {
  final Poll poll;

  const PollViewArguments({required this.poll});
}

class PollView extends StatelessWidget {
  final Poll poll;

  const PollView({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Language.poll),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  Language.keyIdeas,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(poll.summary),
                const SizedBox(height: 20.0),
                const Text(
                  Language.content,
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
        ));
  }
}
