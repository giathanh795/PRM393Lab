// models.dart - Data Model cho Lab 5
// Định nghĩa lớp Movie và Trailer

/// Model đại diện cho một bộ phim
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    this.isFavorite = false,
  });
}

/// Model đại diện cho một trailer của phim
class Trailer {
  final String name;
  final String thumbnailUrl;
  final String youtubeKey;

  const Trailer({
    required this.name,
    required this.thumbnailUrl,
    required this.youtubeKey,
  });
}
