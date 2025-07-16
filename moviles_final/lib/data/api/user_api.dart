import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_dto.dart';

class UserApi {
  static const String baseUrl = 'https://foodapp-eqayckejbjg3eqgn.eastus-01.azurewebsites.net';

  Future<UserDto> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserDto.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }
} 