/// Lab 9.1 Model: Product from asset JSON
class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'description': description,
    };
  }
}

/// Lab 9.2 Model: Task item for file persistence
class TaskItem {
  final String id;
  String title;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

/// Lab 9.3 Model: Mini Database Contact
class Contact {
  final int id;
  String name;
  String phone;
  String email;
  String role;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'Friend',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
    };
  }
}
