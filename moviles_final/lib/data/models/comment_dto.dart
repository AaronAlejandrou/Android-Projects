import '../../domain/entities/comment.dart';

class CommentDto {
  final String id;
  final String user;
  final String content;
  final int rating;
  final DateTime createdAt;

  CommentDto({
    required this.id,
    required this.user,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) => CommentDto(
    id: json['id'].toString(),
    user: json['user'] ?? '',
    content: json['content'] ?? '',
    rating: json['rating'] ?? 0,
    createdAt: DateTime.parse(json['createdAt']),
  );

  Comment toDomain() => Comment(
    id: id,
    user: user,
    content: content,
    rating: rating,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'content': content,
    'rating': rating,
    'createdAt': createdAt.toIso8601String(),
  };
} 