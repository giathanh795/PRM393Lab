import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

/// Root Application Widget
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Genre Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        ),
      ),
      home: const GenreScreen(),
    );
  }
}

/// ============================================================================
/// Step 2: Define Movie Model & Sample Data
/// ============================================================================
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;
  final String overview;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
    required this.overview,
  });
}

const List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500',
    rating: 8.8,
    overview: 'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea.',
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500',
    rating: 9.0,
    overview: 'When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest tests.',
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=500',
    rating: 8.7,
    overview: 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
  ),
  Movie(
    title: 'Parasite',
    year: 2019,
    genres: ['Comedy', 'Drama', 'Thriller'],
    posterUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500',
    rating: 8.5,
    overview: 'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park and destitute Kim families.',
  ),
  Movie(
    title: 'Spirited Away',
    year: 2001,
    genres: ['Animation', 'Adventure', 'Family'],
    posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=500',
    rating: 8.6,
    overview: 'During her family\'s move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits.',
  ),
  Movie(
    title: 'The Grand Budapest Hotel',
    year: 2014,
    genres: ['Adventure', 'Comedy', 'Crime'],
    posterUrl: 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=500',
    rating: 8.1,
    overview: 'A writer encounters the owner of an aging high-class hotel, who tells him of his early years as a legendary lobby boy.',
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    posterUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500',
    rating: 8.4,
    overview: 'After devastating events, the universe is in ruins. With the help of allies, the Avengers assemble once more.',
  ),
  Movie(
    title: 'Whiplash',
    year: 2014,
    genres: ['Drama', 'Music'],
    posterUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500',
    rating: 8.5,
    overview: 'A promising young drummer enrolls at a cut-throat music conservatory where his instructor will stop at nothing.',
  ),
];

const List<String> availableGenres = [
  'Action',
  'Adventure',
  'Animation',
  'Comedy',
  'Crime',
  'Drama',
  'Family',
  'Music',
  'Sci-Fi',
  'Thriller',
];

/// ============================================================================
/// Step 3 - Step 8: GenreScreen (Responsive UI & Filter Logic)
/// ============================================================================
class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Step 4: Search state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Step 5: Genre selection state
  final Set<String> _selectedGenres = {};

  // Step 6: Sort state
  String _selectedSort = 'A-Z';
  final List<String> _sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = 'A-Z';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Step 7: Filter and sort the movie list
    final visibleMovies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase().trim());
      final matchesGenre = _selectedGenres.isEmpty ||
          movie.genres.any((genre) => _selectedGenres.contains(genre));
      return matchesSearch && matchesGenre;
    }).toList();

    switch (_selectedSort) {
      case 'A-Z':
        visibleMovies.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        visibleMovies.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        visibleMovies.sort((a, b) => b.year.compareTo(a.year)); // newest first
        break;
      case 'Rating':
        visibleMovies.sort((a, b) => b.rating.compareTo(a.rating)); // highest first
        break;
    }

    final hasActiveFilter = _searchQuery.isNotEmpty || _selectedGenres.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================================================
              // Lab 6.1: Responsive Hero & Heading Section
              // ===============================================================
              _buildHeaderSection(),

              const SizedBox(height: 12),

              // ===============================================================
              // Lab 6.2 - Part 1: Search Bar
              // ===============================================================
              _buildSearchBar(),

              const SizedBox(height: 12),

              // ===============================================================
              // Lab 6.2 - Part 2: Genre Chips (Wrap) + Clear Filter Button
              // ===============================================================
              _buildGenreChips(hasActiveFilter),

              const SizedBox(height: 8),

              // ===============================================================
              // Lab 6.2 - Part 3: Sort Bar & Result Counter
              // ===============================================================
              _buildSortBar(visibleMovies.length),

              const SizedBox(height: 8),

              // ===============================================================
              // Lab 6.3: Responsive Movie List (Breakpoint 800px)
              // ===============================================================
              Expanded(
                child: _buildResponsiveMovieList(visibleMovies),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Lab 6.1: Heading & Hero Section
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find a Movie',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Explore movies by genre, title, or rating',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.movie_filter_rounded,
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
      ],
    );
  }

  /// Step 4: Search Bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by movie title...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  /// Step 5: Genre Chips with Wrap
  Widget _buildGenreChips(bool hasActiveFilter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Genres',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                if (_selectedGenres.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_selectedGenres.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (hasActiveFilter)
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.refresh, size: 16, color: Colors.redAccent),
                label: const Text(
                  'Clear filters',
                  style: TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: availableGenres.map((genre) {
            final isSelected = _selectedGenres.contains(genre);
            return FilterChip(
              label: Text(genre),
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.deepPurple : Colors.black87,
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedGenres.add(genre);
                  } else {
                    _selectedGenres.remove(genre);
                  }
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.deepPurple.withValues(alpha: 0.18),
              checkmarkColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Step 6: Sort Dropdown & Counter Bar
  Widget _buildSortBar(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count movie${count == 1 ? '' : 's'} found',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            const Text(
              'Sort by: ',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSort,
                  isDense: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSort = newValue;
                      });
                    }
                  },
                  items: _sortOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Lab 6.3: Responsive Movie List using LayoutBuilder
  Widget _buildResponsiveMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No movies match your criteria',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your search query or genres',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint: 800px
        final isWideScreen = constraints.maxWidth >= 800;

        if (isWideScreen) {
          // Tablet / Desktop layout: 2-column GridView
          return GridView.builder(
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        } else {
          // Phone layout: Single-column ListView
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        }
      },
    );
  }
}

/// Movie Card Widget with Responsive Poster & Information
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: ${movie.title} (${movie.year})'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image with fallback errorBuilder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.network(
                movie.posterUrl,
                width: 100,
                height: 135,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 135,
                  color: Colors.grey[800],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie, size: 40, color: Colors.white54),
                      SizedBox(height: 4),
                      Text(
                        'Poster',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Movie details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title and Year
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${movie.year}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.rating} / 10',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Genres badges
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: movie.genres.map((g) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            g,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurple,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 6),
                    // Overview
                    Text(
                      movie.overview,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
