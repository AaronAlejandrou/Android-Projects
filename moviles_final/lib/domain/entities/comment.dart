class Comment {
  final String id;
  final String user;
  final String content;
  final int rating;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.rating,
    required this.createdAt,
  });
} 