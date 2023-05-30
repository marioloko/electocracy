class Poll {
  final String title;
  final String summary;
  final String content;
  final DateTime creationDate;

  Poll({
    required this.title,
    required this.summary,
    required this.content,
    required this.creationDate,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      title: json['title'],
      summary: json['summary'],
      content: json['content'],
      creationDate: DateTime.parse(json['creation_date']),
    );
  }
}
