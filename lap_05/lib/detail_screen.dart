import 'package:flutter/material.dart';
import 'models.dart';

// Detail Screen - Màn hình chi tiết phim
// Nhận Movie object từ HomeScreen qua Navigator.push
class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Optional Enhancement: Favorite toggle với setState()
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.movie.isFavorite = _isFavorite; // Cập nhật object gốc
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? '❤️ Đã thêm vào yêu thích' : '💔 Đã xóa khỏi yêu thích'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          // Share action button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chia sẻ phim: ${movie.title}')),
              );
            },
          ),
        ],
      ),

      // Body - scrollable
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- 1. Hero Banner (Stack + Image.network + gradient) ----
            Stack(
              children: [
                // Poster với Hero animation (cùng tag với HomeScreen)
                Hero(
                  tag: 'poster_${movie.id}',
                  child: Image.network(
                    movie.posterUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) => Container(
                      height: 300,
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, size: 80, color: Colors.white54),
                    ),
                  ),
                ),
                // Gradient overlay phía dưới poster
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // Title overlay phía dưới poster
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // ---- 2. Genres dạng Chip (Column + Wrap + Chip) ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thể loại',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: movie.genres
                        .map(
                          (genre) => Chip(
                            label: Text(genre),
                            backgroundColor: Colors.deepPurple[50],
                            labelStyle: TextStyle(
                              color: Colors.deepPurple[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            // ---- 3. Overview text với Padding ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nội dung phim',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // ---- 4. Action buttons Row (Favorite, Rate, Share) ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hành động',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Favorite button - có setState() để toggle
                      _ActionButton(
                        icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                        label: 'Yêu thích',
                        color: Colors.red,
                        onPressed: _toggleFavorite,
                      ),
                      // Rate button
                      _ActionButton(
                        icon: Icons.star_border,
                        label: 'Đánh giá',
                        color: Colors.amber,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Đánh giá phim'),
                              content: const Text('Tính năng đang phát triển...'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Share button
                      _ActionButton(
                        icon: Icons.share,
                        label: 'Chia sẻ',
                        color: Colors.blue,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đang chia sẻ...')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ---- 5. Trailer list (ListView.builder) ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trailer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            // Sử dụng ListView với shrinkWrap=true bên trong SingleChildScrollView
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: movie.trailers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Tránh scroll conflict
              itemBuilder: (context, index) {
                final trailer = movie.trailers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              trailer.thumbnailUrl,
                              width: 120,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, _) => Container(
                                width: 120,
                                height: 80,
                                color: Colors.grey[800],
                                child: const Icon(Icons.play_circle, color: Colors.white, size: 32),
                              ),
                            ),
                            Container(
                              width: 120,
                              height: 80,
                              color: Colors.black38,
                              child: const Icon(Icons.play_circle_filled, color: Colors.white, size: 36),
                            ),
                          ],
                        ),
                      ),
                      // Trailer name
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trailer.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'YouTube: ${trailer.youtubeKey}',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Widget con cho Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
