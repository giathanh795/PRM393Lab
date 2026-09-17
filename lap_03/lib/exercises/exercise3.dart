// Lab 3 - Exercise 3: Async + Microtask Debugging
// Goal: Differentiate microtask and event queues in Dart event loop.
// - Write a snippet with scheduleMicrotask() and Future(() { ... }).
// - Print execution order.
// - Explain why microtasks run before event callbacks.

import 'dart:async';

void main() async {
  print('====================================================');
  print('  LAB 3 - EXERCISE 3: ASYNC + MICROTASK DEBUGGING   ');
  print('====================================================\n');

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

  // Wait for the event queue callback to finish before exiting
  await eventQueueCompleter.future;

  print('\n>> Explanation of Execution Order:');
  print('1. Dart executes synchronous code in the main thread first ([1] and [2]).');
  print('2. Dart\'s Event Loop contains two queues: Microtask Queue and Event Queue.');
  print('3. The Microtask Queue has higher priority than the Event Queue.');
  print('4. When synchronous code finishes, the Event Loop empties ALL microtasks ([3])');
  print('   before it picks up tasks from the Event Queue ([4]).');
  print('\nExercise 3 completed.');
}
