import 'package:electocracy/app/models/summary.dart';
import 'package:electocracy/app/models/title.dart' as title;
import 'package:electocracy/app/services/electocracy_rest_api.dart';
import 'package:flutter/material.dart';

class SummaryPostView extends StatefulWidget {
  final String content;

  const SummaryPostView({
    super.key,
    required this.content,
  });

  @override
  State<SummaryPostView> createState() => _SummaryPostViewState();
}

class _SummaryPostViewState extends State<SummaryPostView> {
  final _summaryController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Votación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            FutureBuilder<title.Title>(
                future: ElectocracyRestApi.generateTitle(widget.content),
                builder: (context, snapshot) {
                  if (!snapshot.hasData && !snapshot.hasError) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    _titleController.text = snapshot.data!.title;
                  }
                  return TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Título',
                    ),
                  );
                }),
            FutureBuilder<Summary>(
                future: ElectocracyRestApi.summarize(widget.content),
                builder: (context, snapshot) {
                  if (!snapshot.hasData && !snapshot.hasError) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    _summaryController.text = snapshot.data!.summary;
                  }
                  return TextField(
                    controller: _summaryController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Resumen',
                    ),
                  );
                }),
            ElevatedButton(
              child: const Text('Confirmar'),
              onPressed: () {
                // Create new post by sending a request to /post.
              },
            ),
          ],
        ),
      ),
    );
  }
}
