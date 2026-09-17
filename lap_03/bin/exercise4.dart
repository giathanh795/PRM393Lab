// Lab 3 - Exercise 4: Stream Transformation
// Goal: Use functional stream operators.
// - Create a stream of numbers 1-5.
// - Transform values to their squares using map().
// - Filter even numbers with where().
// - Listen and print each emitted value.

import 'dart:async';

void main() async {
  print('====================================================');
  print('     LAB 3 - EXERCISE 4: STREAM TRANSFORMATION      ');
  print('====================================================\n');

  // Create stream of numbers from 1 to 5
  Stream<int> numbersStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('Input numbers: [1, 2, 3, 4, 5]');
  print('Operations: map(n => n * n) -> where(squared => squared.isEven)\n');

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
  print('\nExercise 4 completed.');
}
