import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class Lab91AssetJsonScreen extends StatefulWidget {
  const Lab91AssetJsonScreen({super.key});

  @override
  State<Lab91AssetJsonScreen> createState() => _Lab91AssetJsonScreenState();
}

class _Lab91AssetJsonScreenState extends State<Lab91AssetJsonScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProductsFromAssets();
  }

  /// Lab 9.1: Load and parse JSON file from assets
  Future<List<Product>> _loadProductsFromAssets() async {
    // Step 3: Load JSON using rootBundle.loadString()
    final jsonString = await rootBundle.loadString('assets/data/products.json');

    // Step 4: Convert loaded string into a Dart List using jsonDecode
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Lab 9.1 - Asset JSON Loader'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _productsFuture = _loadProductsFromAssets();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load asset JSON: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.deepOrange.withValues(alpha: 0.08),
                child: Row(
                  children: [
                    const Icon(Icons.folder_special, color: Colors.deepOrange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Loaded ${products.length} products from "assets/data/products.json" using rootBundle & jsonDecode.',
                        style: const TextStyle(fontSize: 13, color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    product.category,
                                    style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${product.rating}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
