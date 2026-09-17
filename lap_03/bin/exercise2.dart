// Lab 3 - Exercise 2: User Repository with JSON
// Goal: Practice JSON serialization / deserialization.
// - Create User { name, email } and User.fromJson(Map) constructor.
// - Simulate JSON list from an API.
// - Use Future<List<User>> to return parsed data.

import 'dart:async';
import 'dart:convert';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Deserialization: Factory constructor to create User from Map/JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  // Serialization: Convert User instance to JSON Map
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };

  @override
  String toString() => 'User(name: "$name", email: "$email")';
}

class UserRepository {
  // Simulates fetching raw JSON data from a REST API and parsing it
  Future<List<User>> fetchUsers() async {
    // Simulated JSON payload returned from API
    String mockApiResponse = '''
    [
      {"name": "Alice Johnson", "email": "alice@example.com"},
      {"name": "Bob Smith", "email": "bob@example.com"},
      {"name": "Charlie Brown", "email": "charlie@example.com"}
    ]
    ''';

    await Future.delayed(const Duration(milliseconds: 400)); // simulate network delay

    // Decode JSON string into List of dynamic objects
    List<dynamic> jsonList = jsonDecode(mockApiResponse) as List<dynamic>;

    // Convert each JSON Map entry into a typed User object
    List<User> users = jsonList
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();

    return users;
  }
}

void main() async {
  print('====================================================');
  print('   LAB 3 - EXERCISE 2: USER REPOSITORY WITH JSON    ');
  print('====================================================\n');

  final userRepo = UserRepository();

  print('Simulating API call to fetch user data in JSON format...');
  List<User> users = await userRepo.fetchUsers();

  print('\nSuccessfully parsed ${users.length} users from JSON:');
  for (int i = 0; i < users.length; i++) {
    print('  [${i + 1}] ${users[i]}');
  }
  print('\nExercise 2 completed.');
}
