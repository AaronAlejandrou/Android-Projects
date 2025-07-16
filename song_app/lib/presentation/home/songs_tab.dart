import 'package:flutter/material.dart';
import '../../data/api_service.dart';
import '../../domain/entities/song_entity.dart';
import 'song_detail_view.dart';

class SongsTab extends StatefulWidget {
  final String token;
  const SongsTab({super.key, required this.token});

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {
  List<SongEntity> _songs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final songs = await ApiService().getSongs(widget.token);
      setState(() {
        _songs = songs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load songs.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    return ListView.builder(
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs[index];
        return Card(
          child: ListTile(
            leading: song.image.isNotEmpty
                ? Image.network(song.image, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.music_note))
                : const Icon(Icons.music_note),
            title: Text(song.title),
            subtitle: Text('${song.artist} • ${song.album}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongDetailView(song: song, token: widget.token),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 