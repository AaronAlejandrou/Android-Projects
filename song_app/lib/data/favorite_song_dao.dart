import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import 'favorite_song_dto.dart';
import '../domain/entities/song_entity.dart';

class FavoriteSongDao {
  Future<void> addFavoriteSong(SongEntity song) async {
    Database db = await AppDatabase().database;
    await db.insert(
      "favorites",
      FavoriteSongDto.fromEntity(song).toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavoriteSong(String id) async {
    Database db = await AppDatabase().database;
    await db.delete("favorites", where: "id = ?", whereArgs: [id]);
  }

  Future<List<SongEntity>> getFavoriteSongs() async {
    Database db = await AppDatabase().database;
    final List maps = await db.query("favorites");
    return maps.map((map) => FavoriteSongDto.fromDatabase(map).toEntity()).toList();
  }

  Future<bool> checkIfFavorite(String id) async {
    Database db = await AppDatabase().database;
    final List maps = await db.query(
      "favorites",
      where: "id = ?",
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
} 