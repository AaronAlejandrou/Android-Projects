import 'package:flutter/material.dart';
import '../../../data/local/favorites_dao.dart';
import '../../../domain/entities/favorite_restaurant.dart';
import '../../restaurants/restaurant_detail_page.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  late Future<List<FavoriteRestaurant>> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _futureFavorites = FavoritesDao().getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FavoriteRestaurant>>(
      future: _futureFavorites,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load favorites'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }
        final favorites = snapshot.data!;
        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final f = favorites[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading: Image.network(f.poster, width: 60, height: 60, fit: BoxFit.cover),
                title: Text(f.title),
                subtitle: Text(f.address),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await FavoritesDao().removeFavorite(f.id);
                    _loadFavorites();
                  },
                ),
                onTap: () {
                  // Optionally, you can pass a token if needed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailPage(restaurant: null, favorite: f),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
} 