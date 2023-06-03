import 'package:electocracy/app/constants/language.dart';
import 'package:electocracy/app/models/poll.dart';
import 'package:electocracy/app/routes/routes.dart';
import 'package:electocracy/app/services/electocracy_rest_api.dart';
import 'package:electocracy/app/views/poll_view.dart';
import 'package:flutter/material.dart';

class PollListView extends StatefulWidget {
  const PollListView({super.key});

  @override
  State<PollListView> createState() => _PollListViewState();
}

class _PollListViewState extends State<PollListView> {
  late Future<List<Poll>> _pollList;

  @override
  void initState() {
    super.initState();
    _pollList = ElectocracyRestApi.listPolls();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _pollList = ElectocracyRestApi.listPolls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(Language.pollList),
        ),
        body: FutureBuilder<List<Poll>>(
          future: _pollList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                  onRefresh: _refreshPosts,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _PollTile(poll: snapshot.data![index]);
                    },
                  ));
            } else if (snapshot.hasError) {
              return const Center(child: Text(Language.errorPollList));
            }
            return const CircularProgressIndicator();
          },
        ),
        floatingActionButton: const _CreatePollButton());
  }
}

class _PollTile extends StatelessWidget {
  final Poll poll;

  const _PollTile({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(poll.title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.pushNamed(context, Routes.poll,
            arguments: PollViewArguments(poll: poll));
      },
    );
  }
}

class _CreatePollButton extends StatelessWidget {
  const _CreatePollButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(
          context,
          Routes.createPoll,
        );
      },
    );
  }
}
