import 'package:electocracy/app/constants/language.dart';
import 'package:electocracy/app/helpers/helpers.dart';
import 'package:electocracy/app/models/comment.dart';
import 'package:electocracy/app/models/poll.dart';
import 'package:electocracy/app/services/electocracy_rest_api.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PollViewArguments {
  final Poll poll;

  const PollViewArguments({required this.poll});
}

class PollView extends StatefulWidget {
  final Poll poll;

  const PollView({super.key, required this.poll});

  @override
  State<PollView> createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  int currentIndex = 0;

  late final List<Widget> _views;

  @override
  void initState() {
    _views = [
      _PollDescriptionView(poll: widget.poll),
      _CommentView(poll: widget.poll),
      _PollVotesView(poll: widget.poll)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Language.poll),
      ),
      body: IndexedStack(index: currentIndex, children: _views),
      bottomNavigationBar: _PollViewNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}

class _PollDescriptionView extends StatelessWidget {
  final Poll poll;

  const _PollDescriptionView({required this.poll});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}

class _CommentView extends StatefulWidget {
  final Poll poll;
  const _CommentView({required this.poll});

  @override
  State<_CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<_CommentView> {
  late Future<List<Comment>> _commentList;

  @override
  void initState() {
    super.initState();
    _commentList = ElectocracyRestApi.listComments(widget.poll.id);
  }

  Future<void> _refreshComments() async {
    setState(() {
      _commentList = ElectocracyRestApi.listComments(widget.poll.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: FutureBuilder<List<Comment>>(
              future: _commentList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                      onRefresh: _refreshComments,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final comment = snapshot.data![index];
                          return ListTile(
                            title: Text(comment.message),
                            contentPadding: EdgeInsets.only(
                              left: comment.parentId == null ? 16.0 : 64.0,
                              right: 16.0,
                            ),
                          );
                        },
                      ));
                } else if (snapshot.hasError) {
                  return const Center(child: Text(Language.errorCommentList));
                }
                return const CircularProgressIndicator();
              })),
      _CreateCommentPanel(poll: widget.poll)
    ]);
  }
}

class _CreateCommentPanel extends StatefulWidget {
  final Poll poll;

  const _CreateCommentPanel({required this.poll});

  @override
  State<_CreateCommentPanel> createState() => _CreateCommentPanelState();
}

class _CreateCommentPanelState extends State<_CreateCommentPanel> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: Language.writeCommentLabel,
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                try {
                  await ElectocracyRestApi.createComment(
                      widget.poll.id, _controller.text);
                } catch (e) {
                  Helpers.snackBarMessage(context, Language.errorCreateComment);
                }
                _controller.clear();
              },
            ),
          ),
        ));
  }
}

class _PollVotesView extends StatelessWidget {
  final Poll poll;
  const _PollVotesView({required this.poll});

  @override
  Widget build(BuildContext context) {
    return PieChart(
        dataMap: const {
          "Yes": 100,
          "No": 50,
          "Other": 20,
          "Just Another": 1,
          "Zero": 0,
          "Extra": 5.0
        },
        chartRadius: MediaQuery.of(context).size.width / 1.5,
        legendOptions: const LegendOptions(
            legendPosition: LegendPosition.bottom, showLegendsInRow: true),
        chartValuesOptions: const ChartValuesOptions(
            showChartValuesOutside: true, showChartValueBackground: false));
  }
}

class _PollViewNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _PollViewNavigationBar(
      {required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: Language.pollDescription),
        BottomNavigationBarItem(
            icon: Icon(Icons.comment_outlined),
            activeIcon: Icon(Icons.comment),
            label: Language.comments),
        BottomNavigationBarItem(
            icon: Icon(Icons.poll_outlined),
            activeIcon: Icon(Icons.poll),
            label: Language.votePoll),
      ],
    );
  }
}
