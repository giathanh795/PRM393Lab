import 'package:flutter/material.dart';

void main() {
  runApp(const Lab2App());
}

class Lab2App extends StatelessWidget {
  const Lab2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2 - Dart Essentials',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Lab2HomePage(),
    );
  }
}

class Lab2HomePage extends StatefulWidget {
  const Lab2HomePage({super.key});

  @override
  State<Lab2HomePage> createState() => _Lab2HomePageState();
}

class _Lab2HomePageState extends State<Lab2HomePage> {
  String _selectedTitle = 'Welcome to Lab 2';
  String _output = 'Bấm chọn một Exercise ở trên để chạy và xem kết quả thực thi.';
  bool _isRunning = false;

  void _runExercise1() {
    setState(() {
      _selectedTitle = 'Exercise 1: Basic Syntax & Data Types';
      _isRunning = true;
    });

    int age = 21;
    double gpa = 3.85;
    String studentName = 'Nguyen Van A';
    bool isEnrolled = true;

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 1: Basic Syntax & Data Types ===\n');
    buffer.writeln('Student Name: $studentName');
    buffer.writeln('Age: $age');
    buffer.writeln('GPA: $gpa');
    buffer.writeln('Enrolled Status: $isEnrolled');
    buffer.writeln('Next year, $studentName will be ${age + 1} years old.');
    buffer.writeln('GPA on 10-point scale: ${(gpa * 2.5).toStringAsFixed(1)}/10');

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  void _runExercise2() {
    setState(() {
      _selectedTitle = 'Exercise 2: Collections & Operators';
      _isRunning = true;
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 2: Collections & Operators ===\n');

    List<int> numbers = [10, 20, 30, 40, 50];
    buffer.writeln('Initial List: $numbers');
    buffer.writeln('Element at index 0: ${numbers[0]}');
    numbers.add(60);
    numbers.remove(20);
    buffer.writeln('List after adding 60 and removing 20: $numbers\n');

    int a = numbers[0];
    int b = numbers[1];
    int sum = a + b;
    int diff = b - a;
    bool isEqual = (a == b);
    bool condition = (a > 5) && (b < 100);

    buffer.writeln('Arithmetic: $a + $b = $sum | $b - $a = $diff');
    buffer.writeln('Comparison: ($a == $b) is $isEqual');
    buffer.writeln('Logical AND: ($a > 5 && $b < 100) is $condition');
    String parity = (sum % 2 == 0) ? 'Even' : 'Odd';
    buffer.writeln('Ternary operator: Sum ($sum) is $parity\n');

    Set<String> skills = {'Flutter', 'Dart', 'Java'};
    skills.add('Flutter');
    skills.add('Python');
    skills.remove('Java');
    buffer.writeln('Skills Set (unique values): $skills\n');

    Map<String, dynamic> studentInfo = {
      'id': 'SE12345',
      'major': 'Software Engineering',
      'year': 3,
    };
    buffer.writeln('Student ID: ${studentInfo['id']}');
    studentInfo['grade'] = 'A';
    studentInfo.remove('year');
    buffer.writeln('Updated Map: $studentInfo');

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  void _runExercise3() {
    setState(() {
      _selectedTitle = 'Exercise 3: Control Flow & Functions';
      _isRunning = true;
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 3: Control Flow & Functions ===\n');

    String evaluateScore(double score) {
      if (score >= 8.5) return 'Excellent';
      if (score >= 7.0) return 'Good';
      if (score >= 5.0) return 'Pass';
      return 'Fail';
    }
    int square(int n) => n * n;

    double myScore = 8.8;
    buffer.writeln('Score: $myScore -> Classification: ${evaluateScore(myScore)}\n');

    int dayNumber = 3;
    String dayName = switch (dayNumber) {
      1 => 'Monday',
      2 => 'Tuesday',
      3 => 'Wednesday',
      4 => 'Thursday',
      5 => 'Friday',
      6 => 'Saturday',
      7 => 'Sunday',
      _ => 'Invalid day',
    };
    buffer.writeln('Day number $dayNumber is: $dayName\n');

    List<String> fruits = ['Apple', 'Banana', 'Orange'];
    buffer.writeln('Standard for loop:');
    for (int i = 0; i < fruits.length; i++) {
      buffer.writeln('  [$i] ${fruits[i]}');
    }
    buffer.writeln('\nfor-in loop:');
    for (var fruit in fruits) {
      buffer.writeln('  - $fruit');
    }
    buffer.writeln('\nforEach() loop:');
    for (var f in fruits) {
      buffer.writeln('  * $f');
    }

    buffer.writeln('\nArrow function: square(7) = ${square(7)}');

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  void _runExercise4() {
    setState(() {
      _selectedTitle = 'Exercise 4: Intro to OOP';
      _isRunning = true;
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 4: Intro to OOP ===\n');

    Car car1 = Car('Toyota');
    buffer.writeln(car1.getInfo());

    Car car2 = Car.unknown();
    buffer.writeln(car2.getInfo());

    ElectricCar tesla = ElectricCar('Tesla Model 3', 75);
    buffer.writeln(tesla.getInfo());

    debugPrint(buffer.toString());
    setState(() {
      _output = buffer.toString();
      _isRunning = false;
    });
  }

  Future<void> _runExercise5() async {
    setState(() {
      _selectedTitle = 'Exercise 5: Async, Null Safety & Streams';
      _isRunning = true;
      _output = 'Running Exercise 5 async simulation... Please wait 1 second.';
    });

    final buffer = StringBuffer();
    buffer.writeln('=== Exercise 5: Async, Null Safety & Streams ===\n');

    String? nullableName;
    buffer.writeln('Nullable variable value: $nullableName');
    String displayName = nullableName ?? 'Default Guest';
    buffer.writeln('Using ?? operator: $displayName');
    nullableName = 'Bob';
    buffer.writeln('Safe access with ?. operator length: ${nullableName.length}');
    buffer.writeln('Null assertion with ! operator: ${nullableName.toUpperCase()}\n');

    buffer.writeln('Simulating Future.delayed() loading...');
    await Future.delayed(const Duration(milliseconds: 600));
    buffer.writeln('Async Result: User: Alice - Data loaded successfully!\n');

    buffer.writeln('Listening to integer Stream:');
    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      buffer.writeln('  Stream emitted value: $i');
    }

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
        title: const Text('PRM393 - Lab 2: Dart Essentials'),
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
                  icon: const Icon(Icons.code),
                  label: const Text('Exercise 1'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise2,
                  icon: const Icon(Icons.list_alt),
                  label: const Text('Exercise 2'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise3,
                  icon: const Icon(Icons.alt_route),
                  label: const Text('Exercise 3'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise4,
                  icon: const Icon(Icons.directions_car),
                  label: const Text('Exercise 4'),
                ),
                ElevatedButton.icon(
                  onPressed: _runExercise5,
                  icon: const Icon(Icons.sync),
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

class Car {
  String brand;
  Car(this.brand);
  Car.unknown() : brand = 'Generic Brand';

  String getInfo() => 'Car Brand: $brand (Gasoline powered)';
}

class ElectricCar extends Car {
  int batteryCapacity;
  ElectricCar(super.brand, this.batteryCapacity);

  @override
  String getInfo() => 'Electric Car Brand: $brand, Battery: ${batteryCapacity}kWh (Zero emission)';
}
