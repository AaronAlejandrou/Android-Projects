class SongEntity {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String year;
  final String duration;
  final String genre;
  final double rating;
  final String image;

  SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.year,
    required this.duration,
    required this.genre,
    required this.rating,
    required this.image,
  });

  factory SongEntity.fromJson(Map<String, dynamic> json) {
    return SongEntity(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      album: json['album'] ?? '',
      year: json['year']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      genre: json['genre'] ?? '',
      rating: (json['rating'] is int) ? (json['rating'] as int).toDouble() : (json['rating'] ?? 0.0),
      image: json['image'] ?? '',
    );
  }
} 