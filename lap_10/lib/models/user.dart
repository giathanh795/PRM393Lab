class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String token;
  final String authProvider; // 'mock', 'dummyjson', 'google'

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.token,
    this.authProvider = 'dummyjson',
  });

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json, {String provider = 'dummyjson'}) {
    return User(
      id: json['id'] as int? ?? 1,
      username: json['username'] as String? ?? 'user',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gender: json['gender'] as String? ?? 'n/a',
      image: json['image'] as String? ?? 'https://dummyjson.com/icon/emilys/128',
      token: (json['accessToken'] ?? json['token']) as String? ?? 'mock-token-xyz',
      authProvider: provider,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'token': token,
      'authProvider': authProvider,
    };
  }
}
