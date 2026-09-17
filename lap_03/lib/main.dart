import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const Lab3App());
}

class Lab3App extends StatelessWidget {
  const Lab3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 - Advanced Dart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Lab3HomePage(),
    );
  }
}

class Lab3HomePage extends StatefulWidget {
  const Lab3HomePage({super.key});

  @override
  State<Lab3HomePage> createState() => _Lab3HomePageState();
}

class _Lab3HomePageState extends State<Lab3HomePage> {
  String _selectedTitle = 'Welcome to Lab 3';
  String _output = 'Bấm chọn một Exercise ở trên để chạy và xem kết quả thực thi.';
  bool _isRunning = false;

  Future<void> _runExercise1() async {
    setState(() {
      _selectedTitle = 'Exercise 1: Product Model & Repository';
      _isRunning = true;
      _output = 'Fetching initial products and listening to live additions...';
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 1: Product Model & Repository ===\n');

    final repo = ProductRepositoryDemo();
    List<ProductDemo> initial = await repo.getAll();
    buffer.writeln('Initial Products:');
    for (var p in initial) {
      buffer.writeln('  - $p');
    }

    buffer.writeln('\nSubscribing to liveAdded() Stream...');
    final sub = repo.liveAdded().listen((p) {
      buffer.writeln('  [LIVE EVENT] New product added: $p');
    });

    await Future.delayed(const Duration(milliseconds: 300));
    repo.addProduct(ProductDemo(id: 3, name: 'Mechanical Keyboard', price: 89.99));

    await Future.delayed(const Duration(milliseconds: 300));
    repo.addProduct(ProductDemo(id: 4, name: 'Dell 27-inch 4K Monitor', price: 349.99));

    await Future.delayed(const Duration(milliseconds: 200));
    await sub.cancel();
    repo.dispose();

    buffer.writeln('\nExercise 1 completed.');
    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  Future<void> _runExercise2() async {
    setState(() {
      _selectedTitle = 'Exercise 2: User Repository with JSON';
      _isRunning = true;
      _output = 'Simulating API call to fetch JSON data...';
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 2: User Repository with JSON ===\n');

    String mockApiResponse = '''
    [
      {"name": "Alice Johnson", "email": "alice@example.com"},
      {"name": "Bob Smith", "email": "bob@example.com"},
      {"name": "Charlie Brown", "email": "charlie@example.com"}
    ]
    ''';

    await Future.delayed(const Duration(milliseconds: 400));
    List<dynamic> jsonList = jsonDecode(mockApiResponse) as List<dynamic>;
    List<UserDemo> users = jsonList.map((e) => UserDemo.fromJson(e as Map<String, dynamic>)).toList();

    buffer.writeln('Successfully parsed ${users.length} users from JSON API:\n');
    for (int i = 0; i < users.length; i++) {
      buffer.writeln('  [${i + 1}] ${users[i]}');
    }
    buffer.writeln('\nExercise 2 completed.');

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  Future<void> _runExercise3() async {
    setState(() {
      _selectedTitle = 'Exercise 3: Async + Microtask Debugging';
      _isRunning = true;
      _output = 'Testing Microtask vs Event queue order...';
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 3: Async + Microtask Debugging ===\n');
    buffer.writeln('[1] Synchronous code starts');

    Completer<void> completer = Completer<void>();

    Future(() {
      buffer.writeln('[4] Future callback executed (from Event Queue)');
      completer.complete();
    });

    scheduleMicrotask(() {
      buffer.writeln('[3] Microtask executed (from Microtask Queue)');
    });

    buffer.writeln('[2] Synchronous code ends');

    await completer.future;

    buffer.writeln('\n>> Explanation of Execution Order:');
    buffer.writeln('1. Dart executes synchronous code in the main thread first ([1] and [2]).');
    buffer.writeln('2. Event Loop contains two queues: Microtask Queue and Event Queue.');
    buffer.writeln('3. Microtask Queue has higher priority than Event Queue.');
    buffer.writeln('4. The Event Loop empties ALL microtasks ([3]) before pulling events ([4]).');
    buffer.writeln('\nExercise 3 completed.');

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  Future<void> _runExercise4() async {
    setState(() {
      _selectedTitle = 'Exercise 4: Stream Transformation';
      _isRunning = true;
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 4: Stream Transformation ===\n');
    buffer.writeln('Input numbers: [1, 2, 3, 4, 5]');
    buffer.writeln('Operations: map(n => n * n) -> where(squared => squared.isEven)\n');

    Stream<int> stream = Stream.fromIterable([1, 2, 3, 4, 5])
        .map((n) => n * n)
        .where((sq) => sq.isEven);

    buffer.writeln('Emitted values from transformed stream:');
    await for (int val in stream) {
      buffer.writeln('  -> Emitted: $val');
    }
    buffer.writeln('\nExercise 4 completed.');

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  void _runExercise5() {
    setState(() {
      _selectedTitle = 'Exercise 5: Factory Constructors & Cache';
      _isRunning = true;
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 5: Factory Constructors & Cache ===\n');

    SettingsDemo s1 = SettingsDemo(theme: 'Dark', language: 'Vietnamese');
    buffer.writeln('Settings instance 1 created: $s1');

    SettingsDemo s2 = SettingsDemo(theme: 'Light', language: 'English');
    buffer.writeln('Settings instance 2 requested: $s2');

    bool isSame = identical(s1, s2);
    buffer.writeln('\nVerification: identical(s1, s2) is $isSame');
    if (isSame) {
      buffer.writeln('Result: Both s1 and s2 share the exact same instance in memory.');
      buffer.writeln('        Factory constructor successfully implements Singleton caching.');
    }
    buffer.writeln('\nExercise 5 completed.');

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRM393 - Lab 3: Advanced Dart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _runExercise1,
                  icon: const Icon(Icons.store),
                  label: const Text('Exercise 1'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise2,
                  icon: const Icon(Icons.people),
                  label: const Text('Exercise 2'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise3,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Exercise 3'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise4,
                  icon: const Icon(Icons.filter_alt),
                  label: const Text('Exercise 4'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise5,
                  icon: const Icon(Icons.settings),
                  label: const Text('Exercise 5'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.terminal, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    if (_isRunning)
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                color: const Color(0xFF1E1E1E),
                elevation: 4,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(
                    _output,
                    style: const TextStyle(
                      color: Color(0xFF4AF626),
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Exercise 1 Models
class ProductDemo {
  final int id;
  final String name;
  final double price;
  ProductDemo({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: "$name", price: \$$price)';
}

class ProductRepositoryDemo {
  final List<ProductDemo> _products = [
    ProductDemo(id: 1, name: 'Laptop Dell XPS', price: 1499.99),
    ProductDemo(id: 2, name: 'Logitech Wireless Mouse', price: 29.99),
  ];
  final StreamController<ProductDemo> _controller = StreamController<ProductDemo>.broadcast();

  Future<List<ProductDemo>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_products);
  }

  Stream<ProductDemo> liveAdded() => _controller.stream;

  void addProduct(ProductDemo p) {
    _products.add(p);
    _controller.add(p);
  }

  void dispose() => _controller.close();
}

// Exercise 2 Models
class UserDemo {
  final String name;
  final String email;
  UserDemo({required this.name, required this.email});

  factory UserDemo.fromJson(Map<String, dynamic> json) {
    return UserDemo(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: "$name", email: "$email")';
}

// Exercise 5 Models
class SettingsDemo {
  static SettingsDemo? _instance;
  String theme;
  String language;

  SettingsDemo._internal({required this.theme, required this.language});

  factory SettingsDemo({String theme = 'Dark', String language = 'English'}) {
    _instance ??= SettingsDemo._internal(theme: theme, language: language);
    return _instance!;
  }

  @override
  String toString() => 'Settings(theme: "$theme", language: "$language", id: $hashCode)';
}
