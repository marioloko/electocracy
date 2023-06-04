class CommentFields {
  static const String id = "id";
  static const String pollId = "poll_id";
  static const String parentId = "parent_id";
  static const String message = "message";
}

class Comment {
  final int id;
  final String pollId;
  final int? parentId;
  final String message;

  Comment({
    required this.id,
    required this.pollId,
    this.parentId,
    required this.message,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json[CommentFields.id],
      pollId: json[CommentFields.pollId],
      parentId: json[CommentFields.parentId],
      message: json[CommentFields.message],
    );
  }
}
