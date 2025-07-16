import 'package:flutter/material.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/entities/comment_entity.dart';
import '../../data/api_service.dart';
import '../../data/favorite_song_dao.dart';

class SongDetailView extends StatefulWidget {
  final SongEntity song;
  final String token;
  const SongDetailView({super.key, required this.song, required this.token});

  @override
  State<SongDetailView> createState() => _SongDetailViewState();
}

class _SongDetailViewState extends State<SongDetailView> {
  bool _isFavorite = false;
  List<CommentEntity> _comments = [];
  bool _loadingComments = true;
  String? _commentError;
  final TextEditingController _commentController = TextEditingController();
  int _rating = 5;
  bool _addingComment = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _fetchComments();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await FavoriteSongDao().checkIfFavorite(widget.song.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoriteSongDao().removeFavoriteSong(widget.song.id);
    } else {
      await FavoriteSongDao().addFavoriteSong(widget.song);
    }
    _checkIfFavorite();
  }

  Future<void> _fetchComments() async {
    setState(() {
      _loadingComments = true;
      _commentError = null;
    });
    try {
      final comments = await ApiService().getComments(widget.song.id, widget.token);
      setState(() {
        _comments = comments;
        _loadingComments = false;
      });
    } catch (e) {
      setState(() {
        _commentError = 'Failed to load comments.';
        _loadingComments = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    setState(() {
      _addingComment = true;
    });
    final success = await ApiService().addComment(
      widget.song.id,
      _commentController.text.trim(),
      _rating,
      widget.token,
    );
    setState(() {
      _addingComment = false;
    });
    if (success) {
      _commentController.clear();
      _rating = 5;
      _fetchComments();
    } else {
      setState(() {
        _commentError = 'Failed to add comment.';
      });
    }
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    return Scaffold(
      appBar: AppBar(title: Text(song.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: song.image.isNotEmpty
                    ? Image.network(song.image, width: 200, height: 200, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.music_note, size: 100))
                    : const Icon(Icons.music_note, size: 100),
              ),
              const SizedBox(height: 16),
              Text(song.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Artist: ${song.artist}'),
              Text('Album: ${song.album}'),
              Text('Year: ${song.year}'),
              Text('Duration: ${song.duration}'),
              Text('Genre: ${song.genre}'),
              Text('Rating: ${song.rating.toStringAsFixed(1)}'),
              const SizedBox(height: 24),
              const Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (_loadingComments)
                const Center(child: CircularProgressIndicator())
              else if (_commentError != null)
                Text(_commentError!, style: const TextStyle(color: Colors.red))
              else if (_comments.isEmpty)
                const Text('No comments yet.')
              else
                ..._comments.map((c) => ListTile(
                      leading: Icon(Icons.person),
                      title: Text(c.comment),
                      subtitle: Row(
                        children: [
                          Text('Rating: ${c.rating}'),
                        ],
                      ),
                    )),
              const SizedBox(height: 24),
              const Text('Add a comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildRatingStars(),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Your comment'),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              if (_addingComment) const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: _addingComment ? null : _addComment,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 