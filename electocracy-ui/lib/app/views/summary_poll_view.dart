import 'package:electocracy/app/constants/language.dart';
import 'package:electocracy/app/helpers/helpers.dart';
import 'package:electocracy/app/models/poll.dart';
import 'package:electocracy/app/routes/routes.dart';
import 'package:electocracy/app/services/electocracy_rest_api.dart';
import 'package:electocracy/app/views/poll_view.dart';
import 'package:electocracy/app/widgets/future_elevated_button.dart';
import 'package:flutter/material.dart';

class SummaryPollViewArguments {
  final String defaultTitle;
  final String defaultSummary;
  final String content;

  const SummaryPollViewArguments(
      {required this.defaultSummary,
      required this.defaultTitle,
      required this.content});
}

class SummaryPollView extends StatefulWidget {
  final String defaultTitle;
  final String defaultSummary;
  final String content;

  const SummaryPollView({
    super.key,
    required this.defaultTitle,
    required this.defaultSummary,
    required this.content,
  });

  @override
  State<SummaryPollView> createState() => _SummaryPollViewState();
}

class _SummaryPollViewState extends State<SummaryPollView> {
  final _summaryController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.defaultTitle;
    _summaryController.text = widget.defaultSummary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Language.pollSummary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: Language.title,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _summaryController,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: Language.keyIdeas,
              ),
            ),
            FutureElevatedButton(
              child: const Text(Language.submit),
              onPressed: () async {
                final Poll poll;
                try {
                  poll = await ElectocracyRestApi.createPoll(
                      _titleController.text,
                      _summaryController.text,
                      widget.content);
                } catch (e) {
                  Helpers.snackBarMessage(context, Language.errorCreatePoll);
                  return;
                }

                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.poll,
                  (route) => route.isFirst,
                  arguments: PollViewArguments(poll: poll),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
