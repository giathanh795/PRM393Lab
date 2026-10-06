import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _sessionKey = 'user_session';
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  /// Lab 10.1: Mock Login (Simulated backend delay & mock credentials)
  Future<User> mockLogin(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (username.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Username and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Mock successful user
    return User(
      id: 99,
      username: username.trim(),
      email: '${username.trim()}@mockdomain.com',
      firstName: 'Mock',
      lastName: 'User',
      gender: 'other',
      image: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      authProvider: 'mock',
    );
  }

  /// Lab 10.2: Real REST API Login via DummyJSON
  Future<User> realApiLogin(String username, String password) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');

    try {
      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'username': username.trim(),
              'password': password.trim(),
              'expiresInMins': 60,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        return User.fromJson(data, provider: 'dummyjson');
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Authentication failed (Code: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error during API login: $e');
    }
  }

  /// Lab 10.4: Firebase / Google Sign-In Simulation
  Future<User> googleSignIn() async {
    await Future.delayed(const Duration(seconds: 2));

    return User(
      id: 101,
      username: 'google_user',
      email: 'user.google@gmail.com',
      firstName: 'Google',
      lastName: 'Account',
      gender: 'male',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      token: 'firebase-google-auth-token-xyz-${DateTime.now().millisecondsSinceEpoch}',
      authProvider: 'google',
    );
  }

  /// Lab 10.3: Session Management with SharedPreferences
  Future<void> saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(user.toJson());
    await prefs.setString(_sessionKey, jsonStr);
  }

  Future<User?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_sessionKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      return User.fromJson(data, provider: data['authProvider'] ?? 'dummyjson');
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
