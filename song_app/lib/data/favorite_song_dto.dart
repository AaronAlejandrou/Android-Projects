import '../domain/entities/song_entity.dart';

class FavoriteSongDto {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String year;
  final String duration;
  final String genre;
  final double rating;
  final String image;

  FavoriteSongDto({
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

  factory FavoriteSongDto.fromDatabase(Map<String, dynamic> map) {
    return FavoriteSongDto(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      year: map['year'],
      duration: map['duration'],
      genre: map['genre'],
      rating: map['rating'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'year': year,
      'duration': duration,
      'genre': genre,
      'rating': rating,
      'image': image,
    };
  }

  factory FavoriteSongDto.fromEntity(SongEntity song) {
    return FavoriteSongDto(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      year: song.year,
      duration: song.duration,
      genre: song.genre,
      rating: song.rating,
      image: song.image,
    );
  }

  SongEntity toEntity() {
    return SongEntity(
      id: id,
      title: title,
      artist: artist,
      album: album,
      year: year,
      duration: duration,
      genre: genre,
      rating: rating,
      image: image,
    );
  }
} 