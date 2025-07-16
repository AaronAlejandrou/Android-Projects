import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../domain/entities/song_entity.dart';
import '../domain/entities/comment_entity.dart';

class ApiService {
  final String baseUrl = 'https://songapp-bkbpafhnhmhwbjbs.eastus-01.azurewebsites.net';

  Future<String?> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/api/users/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body);
      return data['token'];
    }
    return null;
  }

  Future<List<SongEntity>> getSongs(String token) async {
    final uri = Uri.parse('$baseUrl/api/songs');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == HttpStatus.ok) {
      final List list = jsonDecode(response.body);
      return list.map((json) => SongEntity.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<CommentEntity>> getComments(String songId, String token) async {
    final uri = Uri.parse('$baseUrl/api/comments/$songId');
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == HttpStatus.ok) {
      final List list = jsonDecode(response.body);
      return list.map((json) => CommentEntity.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> addComment(String songId, String text, int rating, String token) async {
    final uri = Uri.parse('$baseUrl/api/comments');
    final body = jsonEncode({'songId': int.tryParse(songId) ?? songId, 'comment': text, 'rating': rating});
    final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == HttpStatus.ok || response.statusCode == 201) {
      return true;
    }
    print('Failed to add comment: ${response.statusCode} ${response.body}');
    return false;
  }
} 