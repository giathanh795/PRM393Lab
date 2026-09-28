// sample_data.dart - Dữ liệu mẫu cho Lab 5
// Sử dụng static data, không gọi API

import 'models.dart';

/// Danh sách phim mẫu (static data)
final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Inception',
    posterUrl: 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
    overview:
        'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project and his team to disaster.',
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    rating: 8.8,
    trailers: [
      Trailer(
        name: 'Official Trailer',
        thumbnailUrl: 'https://img.youtube.com/vi/YoHD9XEInc0/hqdefault.jpg',
        youtubeKey: 'YoHD9XEInc0',
      ),
      Trailer(
        name: 'Behind The Scenes',
        thumbnailUrl: 'https://img.youtube.com/vi/66TuSJo4dZM/hqdefault.jpg',
        youtubeKey: '66TuSJo4dZM',
      ),
    ],
  ),
  Movie(
    id: 2,
    title: 'The Dark Knight',
    posterUrl: 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    overview:
        'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
    genres: ['Action', 'Crime', 'Drama'],
    rating: 9.0,
    trailers: [
      Trailer(
        name: 'Official Trailer',
        thumbnailUrl: 'https://img.youtube.com/vi/EXeTwQWrcwY/hqdefault.jpg',
        youtubeKey: 'EXeTwQWrcwY',
      ),
    ],
  ),
  Movie(
    id: 3,
    title: 'Interstellar',
    posterUrl: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    overview:
        'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    rating: 8.6,
    trailers: [
      Trailer(
        name: 'Official Trailer',
        thumbnailUrl: 'https://img.youtube.com/vi/zSWdZVtXT7E/hqdefault.jpg',
        youtubeKey: 'zSWdZVtXT7E',
      ),
    ],
  ),
  Movie(
    id: 4,
    title: 'Parasite',
    posterUrl: 'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
    overview:
        'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.',
    genres: ['Comedy', 'Drama', 'Thriller'],
    rating: 8.5,
    trailers: [
      Trailer(
        name: 'Official Trailer',
        thumbnailUrl: 'https://img.youtube.com/vi/5xH0HfJHsaY/hqdefault.jpg',
        youtubeKey: '5xH0HfJHsaY',
      ),
    ],
  ),
  Movie(
    id: 5,
    title: 'Oppenheimer',
    posterUrl: 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
    overview:
        'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.',
    genres: ['Biography', 'Drama', 'History'],
    rating: 8.3,
    isFavorite: true,
    trailers: [
      Trailer(
        name: 'Official Trailer',
        thumbnailUrl: 'https://img.youtube.com/vi/uYPbbksJxIg/hqdefault.jpg',
        youtubeKey: 'uYPbbksJxIg',
      ),
    ],
  ),
];
