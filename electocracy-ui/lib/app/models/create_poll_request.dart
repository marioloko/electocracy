class CreatePollRequestFields {
  static const String title = "title";
  static const String summary = "summary";
  static const String content = "content";
}

class CreatePollRequest {
  final String title;
  final String summary;
  final String content;

  CreatePollRequest({
    required this.title,
    required this.summary,
    required this.content,
  });

  Map<String, dynamic> get toJson => {
        CreatePollRequestFields.title: title,
        CreatePollRequestFields.summary: summary,
        CreatePollRequestFields.content: content,
      };
}
