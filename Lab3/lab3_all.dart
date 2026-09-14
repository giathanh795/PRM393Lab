// =============================================================================
// Lab 3 - Advanced Dart Practice Exercises
// Course: PRM393 / Mobile Programming
// =============================================================================

import 'dart:async';
import 'dart:convert';

void main() async {
  print('====================================================');
  print('         LAB 3: ADVANCED DART PRACTICE             ');
  print('====================================================\n');

  // Run Exercise 1
  await exercise1();

  // Run Exercise 2
  await exercise2();

  // Run Exercise 3
  await exercise3();

  // Run Exercise 4
  await exercise4();

  // Run Exercise 5
  exercise5();

  print('====================================================');
  print('         ALL EXERCISES COMPLETED SUCCESSFULLY       ');
  print('====================================================');
}

// -----------------------------------------------------------------------------
// EXERCISE 1: Product Model & Repository
// Goal: Understand Futures and Streams.
// - Define Product { id, name, price }.
// - Implement ProductRepository with:
//     * Future<List<Product>> getAll()
//     * Stream<Product> liveAdded() for real-time updates.
//     * Use StreamController.broadcast() to emit new items.
// -----------------------------------------------------------------------------
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: "$name", price: \$$price)';
}

class ProductRepository {
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop Dell XPS', price: 1499.99),
    Product(id: 2, name: 'Logitech Wireless Mouse', price: 29.99),
  ];

  // Broadcast StreamController allows multiple listeners
  final StreamController<Product> _controller = StreamController<Product>.broadcast();

  // Returns all existing products asynchronously via Future
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate loading delay
    return List.unmodifiable(_products);
  }

  // Real-time Stream that emits whenever a new product is added
  Stream<Product> liveAdded() => _controller.stream;

  // Add new product and broadcast it to stream subscribers
  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product);
  }

  void dispose() {
    _controller.close();
  }
}

Future<void> exercise1() async {
  print('--- Exercise 1: Product Model & Repository ---');
  final repo = ProductRepository();

  // 1. Fetch initial products using Future
  print('Fetching initial product list...');
  List<Product> initialList = await repo.getAll();
  print('Initial Products:');
  for (var p in initialList) {
    print('  - $p');
  }

  // 2. Subscribe to real-time additions via Stream
  print('\nSubscribing to liveAdded() Stream...');
  final subscription = repo.liveAdded().listen((newProduct) {
    print('  [LIVE EVENT] New product added: $newProduct');
  });

  // Simulate adding new products over time
  await Future.delayed(const Duration(milliseconds: 300));
  repo.addProduct(Product(id: 3, name: 'Mechanical Keyboard', price: 89.99));

  await Future.delayed(const Duration(milliseconds: 300));
  repo.addProduct(Product(id: 4, name: 'Dell 27-inch 4K Monitor', price: 349.99));

  // Small delay to let stream events finish processing
  await Future.delayed(const Duration(milliseconds: 200));

  await subscription.cancel();
  repo.dispose();
  print('Exercise 1 completed.\n');
}

// -----------------------------------------------------------------------------
// EXERCISE 2: User Repository with JSON
// Goal: Practice JSON serialization / deserialization.
// - Create User { name, email } and User.fromJson(Map) constructor.
// - Simulate JSON list from an API.
// - Use Future<List<User>> to return parsed data.
// -----------------------------------------------------------------------------
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

Future<void> exercise2() async {
  print('--- Exercise 2: User Repository with JSON ---');
  final userRepo = UserRepository();

  print('Simulating API call to fetch user data in JSON format...');
  List<User> users = await userRepo.fetchUsers();

  print('Successfully parsed ${users.length} users from JSON:');
  for (int i = 0; i < users.length; i++) {
    print('  [${i + 1}] ${users[i]}');
  }
  print('Exercise 2 completed.\n');
}

// -----------------------------------------------------------------------------
// EXERCISE 3: Async + Microtask Debugging
// Goal: Differentiate microtask and event queues in Dart event loop.
// - Write a snippet with scheduleMicrotask() and Future(() { ... }).
// - Print execution order.
// - Explain why microtasks run before event callbacks.
// -----------------------------------------------------------------------------
Future<void> exercise3() async {
  print('--- Exercise 3: Async + Microtask Debugging ---');
  print('[1] Synchronous code starts');

  Completer<void> eventQueueCompleter = Completer<void>();

  // 1. Scheduled in the Event Queue (Future constructor)
  Future(() {
    print('[4] Future callback executed (from Event Queue)');
    eventQueueCompleter.complete();
  });

  // 2. Scheduled in the Microtask Queue
  scheduleMicrotask(() {
    print('[3] Microtask executed (from Microtask Queue)');
  });

  // 3. Synchronous code continues
  print('[2] Synchronous code ends');

  // Wait for the event queue callback to finish before exiting exercise
  await eventQueueCompleter.future;

  print('\n>> Explanation of Execution Order:');
  print('1. Dart executes synchronous code in the main thread first ([1] and [2]).');
  print('2. Dart\'s Event Loop contains two queues: Microtask Queue and Event Queue.');
  print('3. The Microtask Queue has higher priority than the Event Queue.');
  print('4. When synchronous code finishes, the Event Loop empties ALL microtasks ([3])');
  print('   before it picks up tasks from the Event Queue ([4]).\n');
}

// -----------------------------------------------------------------------------
// EXERCISE 4: Stream Transformation
// Goal: Use functional stream operators.
// - Create a stream of numbers 1-5.
// - Transform values to their squares using map().
// - Filter even numbers with where().
// - Listen and print each emitted value.
// -----------------------------------------------------------------------------
Future<void> exercise4() async {
  print('--- Exercise 4: Stream Transformation ---');
  // Create stream of numbers from 1 to 5
  Stream<int> numbersStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('Input numbers: [1, 2, 3, 4, 5]');
  print('Operations: map(n => n * n) -> where(squared => squared.isEven)');

  // Transform:
  // 1. map() squares each number (1->1, 2->4, 3->9, 4->16, 5->25)
  // 2. where() filters only even numbers (4, 16)
  Stream<int> transformedStream = numbersStream
      .map((n) => n * n)
      .where((squared) => squared.isEven);

  print('Emitted values from transformed stream:');
  await for (int val in transformedStream) {
    print('  -> Emitted: $val');
  }
  print('Exercise 4 completed.\n');
}

// -----------------------------------------------------------------------------
// EXERCISE 5: Factory Constructors & Cache (Singleton Pattern)
// Goal: Show how factory constructors implement caching and singletons.
// - Create a Settings class with private constructor.
// - Add a factory Settings() that returns a singleton cached instance.
// - Verify two instances refer to the same object (identical(a, b) == true).
// -----------------------------------------------------------------------------
class Settings {
  // Static variable to store single cached instance
  static Settings? _instance;

  String theme;
  String language;

  // Private named constructor prevents direct instantiation from outside
  Settings._internal({required this.theme, required this.language});

  // Factory constructor: returns existing instance if available, or creates a new one
  factory Settings({String theme = 'Dark', String language = 'English'}) {
    _instance ??= Settings._internal(theme: theme, language: language);
    return _instance!;
  }

  @override
  String toString() => 'Settings(theme: "$theme", language: "$language", id: $hashCode)';
}

void exercise5() {
  print('--- Exercise 5: Factory Constructors & Cache ---');

  // Attempt to instantiate first object with Dark theme
  Settings s1 = Settings(theme: 'Dark', language: 'Vietnamese');
  print('Settings instance 1 created: $s1');

  // Attempt to instantiate second object with Light theme
  Settings s2 = Settings(theme: 'Light', language: 'English');
  print('Settings instance 2 requested: $s2');

  // Check if both references point to the exact same object in memory
  bool isSameObject = identical(s1, s2);
  print('\nVerification: identical(s1, s2) is $isSameObject');

  if (isSameObject) {
    print('Result: Both s1 and s2 share the exact same instance in memory.');
    print('        The factory constructor successfully implemented the Singleton pattern with caching.\n');
  }
}
