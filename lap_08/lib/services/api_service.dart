import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Lab 8.1 & 8.4: Fetch posts from REST API
  Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$baseUrl/posts');
    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((item) => Post.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load posts (Status Code: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error occurred: $e');
    }
  }

  /// Lab 8.4 (Optional): Send POST request to create a new post
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final uri = Uri.parse('$baseUrl/posts');
    try {
      final response = await client
          .post(
            uri,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({
              'title': title,
              'body': body,
              'userId': userId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        return Post.fromJson(data);
      } else {
        throw Exception(
          'Failed to create post (Status Code: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to send POST request: $e');
    }
  }
}
