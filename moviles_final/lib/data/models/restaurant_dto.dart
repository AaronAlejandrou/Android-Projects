import '../../domain/entities/restaurant.dart';

class RestaurantDto {
  final int id;
  final String title;
  final String poster;
  final double latitude;
  final double longitude;
  final String address;
  final String phone;
  final String website;
  final double rating;
  final String description;

  RestaurantDto({
    required this.id,
    required this.title,
    required this.poster,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
    required this.website,
    required this.rating,
    required this.description,
  });

  factory RestaurantDto.fromJson(Map<String, dynamic> json) => RestaurantDto(
    id: json['id'],
    title: json['title'],
    poster: json['poster'],
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    address: json['address'],
    phone: json['phone'],
    website: json['website'],
    rating: (json['rating'] as num).toDouble(),
    description: json['description'],
  );

  Restaurant toDomain() => Restaurant(
    id: id,
    title: title,
    poster: poster,
    latitude: latitude,
    longitude: longitude,
    address: address,
    phone: phone,
    website: website,
    rating: rating,
    description: description,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster': poster,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'phone': phone,
    'website': website,
    'rating': rating,
    'description': description,
  };
} 