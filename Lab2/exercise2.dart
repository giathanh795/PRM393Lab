// Lab 2 - Exercise 2: Collections & Operators
// Goal: Work with List, Set, Map and operators (+, -, ==, &&, ? :).
// - Create a List of integers.
// - Use arithmetic & comparison operators.
// - Create a Set (unique values) and a Map (key-value).
// - Use indexing, add(), remove(), and map access.

void main() {
  print('====================================================');
  print('    LAB 2 - EXERCISE 2: COLLECTIONS & OPERATORS     ');
  print('====================================================\n');

  // 1. List of integers
  List<int> numbers = [10, 20, 30, 40, 50];
  print('Initial List: $numbers');

  // Indexing and manipulation (add, remove)
  print('Element at index 0: ${numbers[0]}');
  numbers.add(60);
  numbers.remove(20);
  print('List after adding 60 and removing 20: $numbers\n');

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
  print('Ternary operator: Sum ($sum) is $parity\n');

  // 3. Set (unique elements)
  Set<String> skills = {'Flutter', 'Dart', 'Java'};
  skills.add('Flutter'); // Duplicate value, will be ignored by Set
  skills.add('Python');
  skills.remove('Java');
  print('Skills Set (unique values): $skills\n');

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
  print('Updated Map: $studentInfo');
}
