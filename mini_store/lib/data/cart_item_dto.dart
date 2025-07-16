//import '../domain/cart_item.dart';

class CartItemDto {
  final int id;
  final int quantity;

  CartItemDto({required this.id, required this.quantity});

  factory CartItemDto.fromMap(Map<String, dynamic> map) {
    return CartItemDto(
      id: map['id'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }
} 