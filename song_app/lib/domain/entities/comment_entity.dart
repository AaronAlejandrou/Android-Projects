class CommentEntity {
  final String user;
  final int songId;
  final int rating;
  final String date;
  final String comment;

  CommentEntity({
    required this.user,
    required this.songId,
    required this.rating,
    required this.date,
    required this.comment,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    final userObj = json['user'];
    String userName = '';
    if (userObj != null) {
      userName = '${userObj['firstName'] ?? ''} ${userObj['lastName'] ?? ''}'.trim();
    }
    return CommentEntity(
      user: userName,
      songId: json['songId'] ?? 0,
      rating: json['rating'] ?? 0,
      date: json['date'] ?? '',
      comment: json['comment'] ?? '',
    );
  }
} 