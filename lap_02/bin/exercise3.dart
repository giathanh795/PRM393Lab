// Lab 2 - Exercise 3: Control Flow & Functions
// Goal: Apply if/else, switch, loops, and functions.
// - Write an if/else block to check score.
// - Write a switch case for day of week.
// - Loop through a collection using for, for-in, and forEach().
// - Create a function using normal and arrow syntax.

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

void main() {
  print('====================================================');
  print('   LAB 2 - EXERCISE 3: CONTROL FLOW & FUNCTIONS     ');
  print('====================================================\n');

  // 1. if/else block to check score
  double myScore = 8.8;
  print('Score: $myScore -> Classification: ${evaluateScore(myScore)}\n');

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
  print('Day number $dayNumber is: $dayName\n');

  // 3. Loops through a collection
  List<String> fruits = ['Apple', 'Banana', 'Orange'];

  // Standard for loop
  print('Standard for loop:');
  for (int i = 0; i < fruits.length; i++) {
    print('  [$i] ${fruits[i]}');
  }

  // for-in loop
  print('\nfor-in loop:');
  for (var fruit in fruits) {
    print('  - $fruit');
  }

  // forEach() method
  print('\nforEach() loop:');
  fruits.forEach((fruit) => print('  * $fruit'));

  // 4. Testing arrow function
  int numToSquare = 7;
  print('\nArrow function: square($numToSquare) = ${square(numToSquare)}');
}
