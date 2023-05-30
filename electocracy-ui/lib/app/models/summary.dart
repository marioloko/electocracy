class Summary {
  final String summary;

  Summary({
    required this.summary,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      summary: json['summary'],
    );
  }
}
