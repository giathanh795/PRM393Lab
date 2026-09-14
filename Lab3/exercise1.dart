// Lab 3 - Exercise 1: Product Model & Repository
// Goal: Understand Futures and Streams.
// - Define Product { id, name, price }.
// - Implement ProductRepository with:
//     * Future<List<Product>> getAll()
//     * Stream<Product> liveAdded() for real-time updates.
//     * Use StreamController.broadcast() to emit new items.

import 'dart:async';

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

void main() async {
  print('====================================================');
  print('    LAB 3 - EXERCISE 1: PRODUCT MODEL & REPOSITORY  ');
  print('====================================================\n');

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
  print('\nExercise 1 completed.');
}
