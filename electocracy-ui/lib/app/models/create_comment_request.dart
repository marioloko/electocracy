class CreateCommentRequestFields {
  static const String parentId = "parent_id";
  static const String message = "message";
}

class CreateCommentRequest {
  final int? parentId;
  final String message;

  CreateCommentRequest({
    this.parentId,
    required this.message,
  });

  Map<String, dynamic> get toJson => {
        CreateCommentRequestFields.parentId: parentId,
        CreateCommentRequestFields.message: message,
      };
}
