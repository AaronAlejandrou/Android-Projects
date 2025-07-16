import '../domain/product.dart';

class ProductDto {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingDto rating;

  ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: RatingDto.fromJson(json['rating']),
    );
  }

  Product toDomain() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating.toDomain(),
    );
  }
}

class RatingDto {
  final double rate;
  final int count;

  RatingDto({required this.rate, required this.count});

  factory RatingDto.fromJson(Map<String, dynamic> json) {
    return RatingDto(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'],
    );
  }

  Rating toDomain() {
    return Rating(rate: rate, count: count);
  }
} 