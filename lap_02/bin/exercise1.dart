// Lab 2 - Exercise 1: Basic Syntax & Data Types
// Goal: Practice program structure and variable declarations.
// - Declare variables using: int, double, String, bool.
// - Use print() and string interpolation ($var, ${expr}) to show values.

void main() {
  print('====================================================');
  print('    LAB 2 - EXERCISE 1: BASIC SYNTAX & DATA TYPES   ');
  print('====================================================\n');

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
  print('GPA on 10-point scale: ${(gpa * 2.5).toStringAsFixed(1)}/10');
}
