// Lab 3 - Exercise 5: Factory Constructors & Cache (Singleton Pattern)
// Goal: Show how factory constructors implement caching and singletons.
// - Create a Settings class with private constructor.
// - Add a factory Settings() that returns a singleton cached instance.
// - Verify two instances refer to the same object (identical(a, b) == true).

class Settings {
  // Static variable to store single cached instance
  static Settings? _instance;

  String theme;
  String language;

  // Private named constructor prevents direct instantiation from outside
  Settings._internal({required this.theme, required this.language});

  // Factory constructor: returns existing instance if available, or creates a new one
  factory Settings({String theme = 'Dark', String language = 'English'}) {
    _instance ??= Settings._internal(theme: theme, language: language);
    return _instance!;
  }

  @override
  String toString() => 'Settings(theme: "$theme", language: "$language", id: $hashCode)';
}

void main() {
  print('====================================================');
  print(' LAB 3 - EXERCISE 5: FACTORY CONSTRUCTORS & CACHE   ');
  print('====================================================\n');

  // Attempt to instantiate first object with Dark theme
  Settings s1 = Settings(theme: 'Dark', language: 'Vietnamese');
  print('Settings instance 1 created: $s1');

  // Attempt to instantiate second object with Light theme
  Settings s2 = Settings(theme: 'Light', language: 'English');
  print('Settings instance 2 requested: $s2');

  // Check if both references point to the exact same object in memory
  bool isSameObject = identical(s1, s2);
  print('\nVerification: identical(s1, s2) is $isSameObject');

  if (isSameObject) {
    print('Result: Both s1 and s2 share the exact same instance in memory.');
    print('        The factory constructor successfully implemented the Singleton pattern with caching.');
  }
  print('\nExercise 5 completed.');
}
