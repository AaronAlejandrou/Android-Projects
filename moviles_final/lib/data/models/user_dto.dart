import '../../domain/entities/user.dart';

class UserDto {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  UserDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['userId'] ?? json['id'] ?? '',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    email: json['email'] ?? '',
    token: json['token'] ?? '',
  );

  User toDomain() => User(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    token: token,
  );
} 