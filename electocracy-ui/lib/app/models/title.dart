class TitleFields {
  static const String title = "title";
}

class Title {
  final String title;

  Title({
    required this.title,
  });

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      title: json[TitleFields.title],
    );
  }
}
