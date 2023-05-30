class Title {
  final String title;

  Title({
    required this.title,
  });

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      title: json['title'],
    );
  }
}
