// Lab 2 - Exercise 5: Async, Future, Null Safety & Streams
// Goal: Work with Dart\'s asynchronous features.
// - Create an async function using Future + await.
// - Use Future.delayed() to simulate loading.
// - Practice null-safety operators (?, ??, !).
// - Create a simple Stream of integers and listen to values.

import 'dart:async';

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

void main() async {
  print('====================================================');
  print('  LAB 2 - EXERCISE 5: ASYNC, NULL SAFETY & STREAMS  ');
  print('====================================================\n');

  // 1. Null-safety operators (?, ??, !)
  String? nullableName; // nullable variable
  print('Nullable variable value: $nullableName');

  // Using ?? (if-null operator)
  String displayName = nullableName ?? 'Default Guest';
  print('Using ?? operator: $displayName');

  // Assign value and use ?. and ! operators
  nullableName = 'Bob';
  print('Safe access with ?. operator length: ${nullableName?.length}');
  print('Null assertion with ! operator: ${nullableName!.toUpperCase()}\n');

  // 2. Async/Await with Future
  String result = await fetchUserData();
  print('Async Result: $result\n');

  // 3. Stream of integers
  print('Listening to integer Stream:');
  await for (int number in countStream(3)) {
    print('  Stream emitted value: $number');
  }
}
