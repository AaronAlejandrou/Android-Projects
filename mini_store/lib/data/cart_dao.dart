import 'cart_database.dart';
//import 'cart_item_dto.dart';
import '../domain/cart_item.dart';
//import '../domain/product.dart';
import 'product_service.dart';

class CartDao {
  Future<void> addToCart(int productId) async {
    final db = await CartDatabase().database;
    final existing = await db.query('cart', where: 'id = ?', whereArgs: [productId]);
    if (existing.isNotEmpty) {
      final currentQty = existing.first['quantity'] as int;
      await db.update('cart', {'quantity': currentQty + 1}, where: 'id = ?', whereArgs: [productId]);
    } else {
      await db.insert('cart', {'id': productId, 'quantity': 1});
    }
  }

  Future<void> removeFromCart(int productId) async {
    final db = await CartDatabase().database;
    await db.delete('cart', where: 'id = ?', whereArgs: [productId]);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final db = await CartDatabase().database;
    await db.update('cart', {'quantity': quantity}, where: 'id = ?', whereArgs: [productId]);
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await CartDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    if (maps.isEmpty) return [];
    // Fetch all products to map ids to Product
    final products = await ProductService().fetchProducts();
    return maps.map((map) {
      final product = products.firstWhere((p) => p.id == map['id']);
      return CartItem(product: product, quantity: map['quantity']);
    }).toList();
  }
} 