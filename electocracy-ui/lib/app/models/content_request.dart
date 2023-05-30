class ContentRequest {
  final String content;

  ContentRequest({
    required this.content,
  });

  Map<String, dynamic> get toJson => {
        "content": content,
      };
}
