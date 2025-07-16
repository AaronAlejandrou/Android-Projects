import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/product.dart';
import 'product_dto.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductDto.fromJson(json).toDomain()).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
} 