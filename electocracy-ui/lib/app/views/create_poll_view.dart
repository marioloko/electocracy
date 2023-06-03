import 'package:electocracy/app/constants/language.dart';
import 'package:electocracy/app/helpers/helpers.dart';
import 'package:electocracy/app/models/summary.dart';
import 'package:electocracy/app/models/title.dart' as tm;
import 'package:electocracy/app/routes/routes.dart';
import 'package:electocracy/app/services/electocracy_rest_api.dart';
import 'package:electocracy/app/views/summary_poll_view.dart';
import 'package:electocracy/app/widgets/future_elevated_button.dart';
import 'package:flutter/material.dart';

class CreatePollView extends StatefulWidget {
  const CreatePollView({super.key});

  @override
  State<CreatePollView> createState() => _CreatePollViewState();
}

class _CreatePollViewState extends State<CreatePollView> {
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Language.createPoll),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: Language.content,
              ),
            ),
            FutureElevatedButton(
                child: const Text(Language.submit),
                onPressed: () async {
                  final content = _contentController.text;
                  tm.Title title = tm.Title(title: "");
                  try {
                    title = await ElectocracyRestApi.generateTitle(content);
                  } catch (e) {
                    Helpers.snackBarMessage(
                        context, Language.errorGenerateTitle);
                  }

                  if (!mounted) return;
                  Summary summary = Summary(summary: "");
                  try {
                    summary = await ElectocracyRestApi.summarize(content);
                  } catch (e) {
                    Helpers.snackBarMessage(context, Language.errorSummarize);
                  }

                  if (!mounted) return;
                  Navigator.pushNamed(
                    context,
                    Routes.summaryPoll,
                    arguments: SummaryPollViewArguments(
                        content: content,
                        defaultSummary: summary.summary,
                        defaultTitle: title.title),
                  );
                }),
          ],
        ),
      )),
    );
  }
}
