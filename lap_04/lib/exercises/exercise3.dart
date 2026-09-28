import 'package:flutter/material.dart';

// Exercise 3: Layout Basics - Column, Row, Padding, ListView
// Goal: Build a sectioned UI layout similar to a real app Home screen.
class Exercise3Layout extends StatelessWidget {
  const Exercise3Layout({super.key});

  // Danh sách phim mẫu cho ListView.builder
  static const List<Map<String, String>> _movies = [
    {'title': 'Inception', 'genre': 'Sci-Fi / Thriller', 'year': '2010', 'rating': '8.8'},
    {'title': 'The Dark Knight', 'genre': 'Action / Crime', 'year': '2008', 'rating': '9.0'},
    {'title': 'Interstellar', 'genre': 'Sci-Fi / Adventure', 'year': '2014', 'rating': '8.6'},
    {'title': 'Avengers: Endgame', 'genre': 'Action / Superhero', 'year': '2019', 'rating': '8.4'},
    {'title': 'Parasite', 'genre': 'Drama / Thriller', 'year': '2019', 'rating': '8.5'},
    {'title': 'Joker', 'genre': 'Drama / Crime', 'year': '2019', 'rating': '8.4'},
    {'title': 'Dune', 'genre': 'Sci-Fi / Adventure', 'year': '2021', 'rating': '8.0'},
    {'title': 'Oppenheimer', 'genre': 'Biography / Drama', 'year': '2023', 'rating': '8.3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 - Layout Basics'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------ SECTION 1: Header với Row ------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phim Nổi Bật',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Danh sách phim được yêu thích',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_movies.length} phim',
                    style: TextStyle(color: Colors.indigo[700], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // ------ SECTION 2: Category chips với Row + SingleChildScrollView ------
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Tất cả', 'Action', 'Sci-Fi', 'Drama', 'Thriller'].map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text(cat),
                      backgroundColor: cat == 'Tất cả' ? Colors.indigo : Colors.indigo[50],
                      labelStyle: TextStyle(
                        color: cat == 'Tất cả' ? Colors.white : Colors.indigo[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),

          // ------ SECTION 3: ListView.builder hiển thị danh sách phim ------
          Expanded(
            child: ListView.builder(
              // Sử dụng Expanded để tránh lỗi "Vertical viewport was given unbounded height"
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0), // Consistent spacing 12px
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Index circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.indigo[100],
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.indigo[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Movie info (Column bên trong Row)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${movie["genre"]} • ${movie["year"]}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Rating
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                movie['rating']!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
