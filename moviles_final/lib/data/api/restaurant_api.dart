import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_dto.dart';

class RestaurantApi {
  static const String baseUrl = 'https://foodapp-eqayckejbjg3eqgn.eastus-01.azurewebsites.net';

  Future<List<RestaurantDto>> getRestaurants(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/restaurants'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => RestaurantDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
} 