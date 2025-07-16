import 'package:flutter/material.dart';
import '../../data/favorite_song_dao.dart';
import '../../domain/entities/song_entity.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  List<SongEntity> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _loading = true;
    });
    final favs = await FavoriteSongDao().getFavoriteSongs();
    setState(() {
      _favorites = favs;
      _loading = false;
    });
  }

  Future<void> _removeFavorite(String id) async {
    await FavoriteSongDao().removeFavoriteSong(id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_favorites.isEmpty) {
      return const Center(child: Text('No favorites yet.'));
    }
    return ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final song = _favorites[index];
        return Card(
          child: ListTile(
            leading: song.image.isNotEmpty
                ? Image.network(song.image, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.music_note))
                : const Icon(Icons.music_note),
            title: Text(song.title),
            subtitle: Text('${song.artist} • ${song.genre}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeFavorite(song.id),
            ),
          ),
        );
      },
    );
  }
} 