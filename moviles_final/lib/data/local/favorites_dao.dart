import 'app_database.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/favorite_restaurant.dart';

class FavoritesDao {
  Future<void> addFavorite(FavoriteRestaurant restaurant) async {
    final db = await AppDatabase().database;
    await db.insert(
      'favorites',
      {
        'id': restaurant.id,
        'title': restaurant.title,
        'poster': restaurant.poster,
        'address': restaurant.address,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await AppDatabase().database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FavoriteRestaurant>> getFavorites() async {
    final db = await AppDatabase().database;
    final maps = await db.query('favorites');
    return maps.map((e) => FavoriteRestaurant(
      id: e['id'] as int,
      title: e['title'] as String,
      poster: e['poster'] as String,
      address: e['address'] as String,
    )).toList();
  }

  Future<bool> isFavorite(int id) async {
    final db = await AppDatabase().database;
    final maps = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty;
  }
} 