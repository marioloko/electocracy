class SummaryFields {
  static const String summary = "summary";
}

class Summary {
  final String summary;

  Summary({
    required this.summary,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      summary: json[SummaryFields.summary],
    );
  }
}
