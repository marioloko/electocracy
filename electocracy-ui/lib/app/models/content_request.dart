class ContentRequestFields {
  static const String content = "content";
}

class ContentRequest {
  final String content;

  ContentRequest({
    required this.content,
  });

  Map<String, dynamic> get toJson => {
        ContentRequestFields.content: content,
      };
}
