import 'package:flutter/material.dart';

// Exercise 1: Core Widgets - Text, Image, Icon, Card, ListTile
// Goal: Build a simple UI demonstrating essential Flutter display widgets.
class Exercise1CoreWidgets extends StatelessWidget {
  const Exercise1CoreWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 - Core Widgets'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Headline Text
            const Text(
              'Flutter Core Widgets Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Showcasing Text, Image, Icon, Card và ListTile widgets',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 2. Icon using Material Icons
            const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                SizedBox(width: 8),
                Icon(Icons.favorite, color: Colors.red, size: 32),
                SizedBox(width: 8),
                Icon(Icons.thumb_up, color: Colors.blue, size: 32),
                SizedBox(width: 8),
                Icon(Icons.movie, color: Colors.deepPurple, size: 32),
              ],
            ),

            const SizedBox(height: 20),

            // 3. Image.network()
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Square_200x200.png/200px-Square_200x200.png',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Image placeholder', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey[100],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 4. Card containing a ListTile
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  'Nguyen Van A',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Flutter Developer - PRM393'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),

            const SizedBox(height: 12),

            // Extra: More Card examples
            Card(
              elevation: 2,
              color: Colors.deepPurple[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.movie, color: Colors.deepPurple, size: 32),
                title: Text('Inception', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Christopher Nolan • 2010 • ⭐ 8.8/10'),
                trailing: Icon(Icons.favorite_border, color: Colors.red),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.movie, color: Colors.orange, size: 32),
                title: Text('The Dark Knight', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Christopher Nolan • 2008 • ⭐ 9.0/10'),
                trailing: Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
