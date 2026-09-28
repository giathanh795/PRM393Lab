import 'package:flutter/material.dart';
import 'models.dart';
import 'sample_data.dart';
import 'detail_screen.dart';

// Home Screen - Hiển thị danh sách phim dạng ListView.builder
// Nhấn vào phim -> navigate đến Movie Detail Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Danh sách phim (có thể lọc theo search)
  List<Movie> _displayedMovies = sampleMovies;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Optional Enhancement: Tìm kiếm phim theo tên
  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedMovies = sampleMovies;
      } else {
        _displayedMovies = sampleMovies
            .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('🎬 Movie App'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Danh sách yêu thích')),
              );
            },
          ),
        ],
      ),

      // Body
      body: Column(
        children: [
          // Search bar (Optional Enhancement)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm phim...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Movie list header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Phim nổi bật',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_displayedMovies.length} phim',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ListView.builder hiển thị danh sách phim
          Expanded(
            child: _displayedMovies.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Không tìm thấy phim', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: _displayedMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _displayedMovies[index];
                      return _MovieCard(
                        movie: movie,
                        onTap: () {
                          // Navigator.push + MaterialPageRoute để điều hướng
                          // Truyền Movie object sang màn hình chi tiết
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(movie: movie),
                            ),
                          ).then((_) {
                            // Khi quay lại, refresh để cập nhật favorite
                            setState(() {});
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget hiển thị một movie card trong danh sách
class _MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _MovieCard({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              // Poster với Hero animation để transition mượt sang DetailScreen
              Hero(
                tag: 'poster_${movie.id}', // Tag unique cho mỗi phim
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    movie.posterUrl,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) => Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
              ),

              // Movie info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Genres (hiển thị tối đa 2)
                      Text(
                        movie.genres.take(2).join(' • '),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Rating + Favorite
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const Spacer(),
                          if (movie.isFavorite)
                            const Icon(Icons.favorite, color: Colors.red, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Arrow
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
