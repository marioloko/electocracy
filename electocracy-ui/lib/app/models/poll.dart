class PollFields {
  static const String id = "id";
  static const String title = "title";
  static const String summary = "summary";
  static const String content = "content";
  static const String creationDate = "creation_date";
}

class Poll {
  final String id;
  final String title;
  final String summary;
  final String content;
  final DateTime creationDate;

  Poll({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.creationDate,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json[PollFields.id],
      title: json[PollFields.title],
      summary: json[PollFields.summary],
      content: json[PollFields.content],
      creationDate: DateTime.parse(json[PollFields.creationDate]),
    );
  }
}
