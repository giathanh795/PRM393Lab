// =============================================================================
// Lab 2 - Dart Essentials Practice Lab
// Course: PRM393 / Mobile Programming
// =============================================================================

import 'dart:async';

void main() async {
  print('====================================================');
  print('          LAB 2: DART ESSENTIALS PRACTICE           ');
  print('====================================================\n');

  // Run Exercise 1
  exercise1();

  // Run Exercise 2
  exercise2();

  // Run Exercise 3
  exercise3();

  // Run Exercise 4
  exercise4();

  // Run Exercise 5
  await exercise5();

  print('\n====================================================');
  print('         ALL EXERCISES COMPLETED SUCCESSFULLY       ');
  print('====================================================');
}

// -----------------------------------------------------------------------------
// EXERCISE 1: Basic Syntax & Data Types
// Goal: Practice program structure and variable declarations.
// - Declare variables using: int, double, String, bool.
// - Use print() and string interpolation ($var, ${expr}) to show values.
// -----------------------------------------------------------------------------
void exercise1() {
  print('--- Exercise 1: Basic Syntax & Data Types ---');

  // Declaring variables of core types
  int age = 21;
  double gpa = 3.85;
  String studentName = 'Nguyen Van A';
  bool isEnrolled = true;

  // Using print() and string interpolation ($var)
  print('Student Name: $studentName');
  print('Age: $age');
  print('GPA: $gpa');
  print('Enrolled Status: $isEnrolled');

  // String interpolation with expression (${...})
  print('Next year, $studentName will be ${age + 1} years old.');
  print('GPA on 10-point scale: ${(gpa * 2.5).toStringAsFixed(1)}/10\n');
}

// -----------------------------------------------------------------------------
// EXERCISE 2: Collections & Operators
// Goal: Work with List, Set, Map and operators (+, -, ==, &&, ? :).
// - Create a List of integers.
// - Use arithmetic & comparison operators.
// - Create a Set (unique values) and a Map (key-value).
// - Use indexing, add(), remove(), and map access.
// -----------------------------------------------------------------------------
void exercise2() {
  print('--- Exercise 2: Collections & Operators ---');

  // 1. List of integers
  List<int> numbers = [10, 20, 30, 40, 50];
  print('Initial List: $numbers');

  // Indexing and manipulation (add, remove)
  print('Element at index 0: ${numbers[0]}');
  numbers.add(60);
  numbers.remove(20);
  print('List after adding 60 and removing 20: $numbers');

  // 2. Arithmetic and comparison operators (+, -, ==, &&)
  int a = numbers[0]; // 10
  int b = numbers[1]; // 30
  int sum = a + b;
  int diff = b - a;
  bool isEqual = (a == b);
  bool condition = (a > 5) && (b < 100);

  print('Arithmetic: $a + $b = $sum | $b - $a = $diff');
  print('Comparison: ($a == $b) is $isEqual');
  print('Logical AND: ($a > 5 && $b < 100) is $condition');

  // Ternary operator (? :)
  String parity = (sum % 2 == 0) ? 'Even' : 'Odd';
  print('Ternary operator: Sum ($sum) is $parity');

  // 3. Set (unique elements)
  Set<String> skills = {'Flutter', 'Dart', 'Java'};
  skills.add('Flutter'); // Duplicate value, will be ignored by Set
  skills.add('Python');
  skills.remove('Java');
  print('Skills Set (unique values): $skills');

  // 4. Map (key-value pairs)
  Map<String, dynamic> studentInfo = {
    'id': 'SE12345',
    'major': 'Software Engineering',
    'year': 3,
  };
  // Map access, adding new key-value, and removal
  print('Student ID: ${studentInfo['id']}');
  studentInfo['grade'] = 'A'; // Add new entry
  studentInfo.remove('year'); // Remove entry
  print('Updated Map: $studentInfo\n');
}

// -----------------------------------------------------------------------------
// EXERCISE 3: Control Flow & Functions
// Goal: Apply if/else, switch, loops, and functions.
// - Write an if/else block to check score.
// - Write a switch case for day of week.
// - Loop through a collection using for, for-in, and forEach().
// - Create a function using normal and arrow syntax.
// -----------------------------------------------------------------------------
// Normal syntax function
String evaluateScore(double score) {
  if (score >= 8.5) {
    return 'Excellent';
  } else if (score >= 7.0) {
    return 'Good';
  } else if (score >= 5.0) {
    return 'Pass';
  } else {
    return 'Fail';
  }
}

// Arrow syntax function
int square(int n) => n * n;

void exercise3() {
  print('--- Exercise 3: Control Flow & Functions ---');

  // 1. if/else block to check score
  double myScore = 8.8;
  print('Score: $myScore -> Classification: ${evaluateScore(myScore)}');

  // 2. switch case for day of week
  int dayNumber = 3;
  String dayName;
  switch (dayNumber) {
    case 1:
      dayName = 'Monday';
      break;
    case 2:
      dayName = 'Tuesday';
      break;
    case 3:
      dayName = 'Wednesday';
      break;
    case 4:
      dayName = 'Thursday';
      break;
    case 5:
      dayName = 'Friday';
      break;
    case 6:
      dayName = 'Saturday';
      break;
    case 7:
      dayName = 'Sunday';
      break;
    default:
      dayName = 'Invalid day';
  }
  print('Day number $dayNumber is: $dayName');

  // 3. Loops through a collection
  List<String> fruits = ['Apple', 'Banana', 'Orange'];

  // Standard for loop
  print('Standard for loop:');
  for (int i = 0; i < fruits.length; i++) {
    print('  [$i] ${fruits[i]}');
  }

  // for-in loop
  print('for-in loop:');
  for (var fruit in fruits) {
    print('  - $fruit');
  }

  // forEach() method
  print('forEach() loop:');
  fruits.forEach((fruit) => print('  * $fruit'));

  // 4. Testing arrow function
  int numToSquare = 7;
  print('Arrow function: square($numToSquare) = ${square(numToSquare)}\n');
}

// -----------------------------------------------------------------------------
// EXERCISE 4: Intro to OOP
// Goal: Practice classes, objects, constructors, inheritance, and overriding.
// - Create a class Car with one property and a method.
// - Create a named constructor.
// - Create a subclass ElectricCar that overrides a method.
// - Instantiate objects and print results.
// -----------------------------------------------------------------------------
// Base class Car
class Car {
  String brand;

  // Default constructor
  Car(this.brand);

  // Named constructor
  Car.unknown() : brand = 'Generic Brand';

  // Method
  void displayInfo() {
    print('Car Brand: $brand (Gasoline powered)');
  }
}

// Subclass ElectricCar inheriting from Car
class ElectricCar extends Car {
  int batteryCapacity; // in kWh

  // Constructor calling super constructor
  ElectricCar(super.brand, this.batteryCapacity);

  // Method overriding
  @override
  void displayInfo() {
    print('Electric Car Brand: $brand, Battery: ${batteryCapacity}kWh (Zero emission)');
  }
}

void exercise4() {
  print('--- Exercise 4: Intro to OOP ---');

  // Default constructor instantiation
  Car car1 = Car('Toyota');
  car1.displayInfo();

  // Named constructor instantiation
  Car car2 = Car.unknown();
  car2.displayInfo();

  // Subclass instantiation & overridden method execution
  ElectricCar tesla = ElectricCar('Tesla Model 3', 75);
  tesla.displayInfo();

  print('');
}

// -----------------------------------------------------------------------------
// EXERCISE 5: Async, Future, Null Safety & Streams
// Goal: Work with Dart\'s asynchronous features.
// - Create an async function using Future + await.
// - Use Future.delayed() to simulate loading.
// - Practice null-safety operators (?, ??, !).
// - Create a simple Stream of integers and listen to values.
// -----------------------------------------------------------------------------
// Async function simulating network loading using Future.delayed()
Future<String> fetchUserData() async {
  print('Fetching user data from server...');
  await Future.delayed(const Duration(seconds: 1)); // 1 second loading delay
  return 'User: Alice - Data loaded successfully!';
}

// Generator function creating a Stream of integers
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(const Duration(milliseconds: 300));
    yield i;
  }
}

Future<void> exercise5() async {
  print('--- Exercise 5: Async, Future, Null Safety & Streams ---');

  // 1. Null-safety operators (?, ??, !)
  String? nullableName; // nullable variable
  print('Nullable variable value: $nullableName');

  // Using ?? (if-null operator)
  String displayName = nullableName ?? 'Default Guest';
  print('Using ?? operator: $displayName');

  // Assign value and use ?. and ! operators
  nullableName = 'Bob';
  print('Safe access with ?. operator length: ${nullableName?.length}');
  print('Null assertion with ! operator: ${nullableName!.toUpperCase()}');

  // 2. Async/Await with Future
  String result = await fetchUserData();
  print('Async Result: $result');

  // 3. Stream of integers
  print('Listening to integer Stream:');
  await for (int number in countStream(3)) {
    print('  Stream emitted value: $number');
  }
}
