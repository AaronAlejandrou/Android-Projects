import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment_dto.dart';

class CommentApi {
  static const String baseUrl = 'https://foodapp-eqayckejbjg3eqgn.eastus-01.azurewebsites.net';

  Future<List<CommentDto>> getComments(String restaurantId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/comments/$restaurantId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => CommentDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment({
    required String restaurantId,
    required String content,
    required int rating,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/comments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'restaurantId': restaurantId,
        'content': content,
        'rating': rating,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  }
} 