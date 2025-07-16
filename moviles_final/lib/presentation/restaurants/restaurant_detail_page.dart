import 'package:flutter/material.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/favorite_restaurant.dart';
import '../../data/api/comment_api.dart';
import '../../data/local/favorites_dao.dart';
import '../../domain/entities/comment.dart';
import '../comments/add_comment_dialog.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant? restaurant;
  final FavoriteRestaurant? favorite;
  final String? token;
  const RestaurantDetailPage({super.key, this.restaurant, this.favorite, this.token});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool _isFavorite = false;
  List<Comment> _comments = [];
  bool _loadingComments = true;

  Restaurant get _restaurant => widget.restaurant ?? Restaurant(
    id: widget.favorite!.id,
    title: widget.favorite!.title,
    poster: widget.favorite!.poster,
    latitude: 0,
    longitude: 0,
    address: widget.favorite!.address,
    phone: '',
    website: '',
    rating: 0,
    description: '',
  );

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    _loadComments();
  }

  Future<void> _checkFavorite() async {
    final isFav = await FavoritesDao().isFavorite(_restaurant.id);
    if (mounted) setState(() => _isFavorite = isFav);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesDao().removeFavorite(_restaurant.id);
    } else {
      await FavoritesDao().addFavorite(
        FavoriteRestaurant(
          id: _restaurant.id,
          title: _restaurant.title,
          poster: _restaurant.poster,
          address: _restaurant.address,
        ),
      );
    }
    _checkFavorite();
  }

  Future<void> _loadComments() async {
    if (widget.token == null) return;
    setState(() => _loadingComments = true);
    try {
      final dtos = await CommentApi().getComments(_restaurant.id.toString(), widget.token!);
      setState(() {
        _comments = dtos.map((e) => e.toDomain()).toList();
        _loadingComments = false;
      });
    } catch (e) {
      setState(() => _loadingComments = false);
    }
  }

  Future<void> _addComment() async {
    if (widget.token == null) return;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddCommentDialog(),
    );
    if (result != null) {
      try {
        await CommentApi().addComment(
          restaurantId: _restaurant.id.toString(),
          content: result['content'],
          rating: result['rating'],
          token: widget.token!,
        );
        _loadComments();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comment added!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add comment')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _restaurant;
    return Scaffold(
      appBar: AppBar(
        title: Text(r.title),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      floatingActionButton: widget.token != null
          ? FloatingActionButton.extended(
              onPressed: _addComment,
              icon: const Icon(Icons.add_comment),
              label: const Text('Add Comment'),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (r.poster.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(r.poster, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text(r.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          if (r.rating > 0) Text('Rating: ${r.rating.toStringAsFixed(1)}'),
          if (r.phone.isNotEmpty) Text('Phone: ${r.phone}'),
          if (r.website.isNotEmpty) Text('Website: ${r.website}'),
          if (r.address.isNotEmpty) Text('Address: ${r.address}'),
          if (r.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(r.description),
          ],
          const SizedBox(height: 24),
          const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (_loadingComments)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_comments.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No comments yet'),
            )
          else
            ..._comments.map((c) => ListTile(
                  title: Text(c.content),
                  subtitle: Text('By ${c.user} - ${c.rating}★'),
                  trailing: Text('${c.createdAt.toLocal()}'.split(' ')[0]),
                )),
        ],
      ),
    );
  }
} 