import 'package:electocracy/app/views/create_poll_view.dart';
import 'package:electocracy/app/views/not_found_view.dart';
import 'package:electocracy/app/views/poll_list_view.dart';
import 'package:electocracy/app/views/poll_view.dart';
import 'package:electocracy/app/views/summary_poll_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String polls = "/";
  static const String poll = "/poll";
  static const String createPoll = "/create-poll";
  static const String summaryPoll = "/summary-poll";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case polls:
        return MaterialPageRoute(builder: (_) => const PollListView());
      case poll:
        // Extract any arguments from the settings if needed.
        final PollViewArguments args = settings.arguments as PollViewArguments;
        return MaterialPageRoute(builder: (_) => PollView(poll: args.poll));
      case createPoll:
        return MaterialPageRoute(builder: (_) => const CreatePollView());
      case summaryPoll:
        // Extract any arguments from the settings if needed.
        final SummaryPollViewArguments args =
            settings.arguments as SummaryPollViewArguments;
        return MaterialPageRoute(
            builder: (_) => SummaryPollView(
                content: args.content,
                defaultTitle: args.defaultTitle,
                defaultSummary: args.defaultSummary));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => const NotFoundView());
    }
  }
}
