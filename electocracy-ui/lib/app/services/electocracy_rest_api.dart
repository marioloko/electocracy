import 'dart:convert';

import 'package:electocracy/app/constants/language.dart';
import 'package:electocracy/app/models/comment.dart';
import 'package:electocracy/app/models/content_request.dart';
import 'package:electocracy/app/models/create_comment_request.dart';
import 'package:electocracy/app/models/create_poll_request.dart';
import 'package:electocracy/app/models/poll.dart';
import 'package:electocracy/app/models/summary.dart';
import 'package:electocracy/app/models/title.dart';
import 'package:http/http.dart' as http;

class ElectocracyRestApi {
  static const String _electocracyRestApiAddress = 'localhost:8000';

  static Future<List<Poll>> listPolls() async {
    final response =
        await http.get(Uri.parse('http://$_electocracyRestApiAddress/poll'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((poll) => Poll.fromJson(poll)).toList();
    } else {
      throw Exception('Failed to load polls');
    }
  }

  static Future<List<Comment>> listComments(String pollId) async {
    final response = await http.get(
        Uri.parse('http://$_electocracyRestApiAddress/poll/$pollId/comment'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((poll) => Comment.fromJson(poll)).toList();
    } else {
      throw Exception('Failed to load polls');
    }
  }

  static Future<Title> generateTitle(String content) async {
    final body = jsonEncode(ContentRequest(content: content).toJson);

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
        Uri.parse('http://$_electocracyRestApiAddress/generate-title'),
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return Title.fromJson(jsonResponse);
    } else {
      throw Exception(Language.errorGenerateTitle);
    }
  }

  static Future<Summary> summarize(String content) async {
    final body = jsonEncode(ContentRequest(content: content).toJson);

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
        Uri.parse('http://$_electocracyRestApiAddress/summarize'),
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return Summary.fromJson(jsonResponse);
    } else {
      throw Exception(Language.errorSummarize);
    }
  }

  static Future<Poll> createPoll(
      String title, String summary, String content) async {
    final body = jsonEncode(
        CreatePollRequest(title: title, summary: summary, content: content)
            .toJson);

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
        Uri.parse('http://$_electocracyRestApiAddress/poll'),
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return Poll.fromJson(jsonResponse);
    } else {
      throw Exception(Language.errorCreatePoll);
    }
  }

  static Future<Comment> createComment(String pollId, String message,
      {int? parentId}) async {
    final body = jsonEncode(
        CreateCommentRequest(parentId: parentId, message: message).toJson);

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
        Uri.parse('http://$_electocracyRestApiAddress/poll/$pollId/comment'),
        body: body,
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return Comment.fromJson(jsonResponse);
    } else {
      throw Exception("Error creating new comment");
    }
  }
}
