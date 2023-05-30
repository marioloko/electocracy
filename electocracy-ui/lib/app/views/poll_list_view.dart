import 'package:electocracy/app/models/poll.dart';
import 'package:electocracy/app/services/electocracy_rest_api.dart';
import 'package:electocracy/app/views/create_post_view.dart';
import 'package:electocracy/app/views/poll_view.dart';
import 'package:flutter/material.dart';

class PollsListView extends StatelessWidget {
  const PollsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Votaciones'),
        ),
        body: FutureBuilder<List<Poll>>(
          future: ElectocracyRestApi.listPolls(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PollView(poll: snapshot.data![index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePostView(),
              ),
            );
          },
        ));
  }
}
