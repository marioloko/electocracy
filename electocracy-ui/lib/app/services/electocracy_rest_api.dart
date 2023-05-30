import 'dart:convert';

import 'package:electocracy/app/models/content_request.dart';
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
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((poll) => Poll.fromJson(poll)).toList();
    } else {
      throw Exception('Failed to load polls');
    }
  }

  static Future<Title> generateTitle(String content) async {
    final contentRequest = ContentRequest(content: content);
    final response = await http.post(
        Uri.parse('http://$_electocracyRestApiAddress/generate-title'),
        body: json.encode(contentRequest.toJson));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Title.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to generate title for poll');
    }
  }

  static Future<Summary> summarize(String content) async {
    final contentRequest = ContentRequest(content: content);
    final response = await http.post(
        Uri.parse('http://$_electocracyRestApiAddress/summarize'),
        body: json.encode(contentRequest.toJson));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Summary.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to generate summary for poll');
    }
  }
}
