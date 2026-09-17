// Lab 2 - Exercise 4: Intro to OOP
// Goal: Practice classes, objects, constructors, inheritance, and overriding.
// - Create a class Car with one property and a method.
// - Create a named constructor.
// - Create a subclass ElectricCar that overrides a method.
// - Instantiate objects and print results.

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

void main() {
  print('====================================================');
  print('           LAB 2 - EXERCISE 4: INTRO TO OOP         ');
  print('====================================================\n');

  // Default constructor instantiation
  Car car1 = Car('Toyota');
  car1.displayInfo();

  // Named constructor instantiation
  Car car2 = Car.unknown();
  car2.displayInfo();

  // Subclass instantiation & overridden method execution
  ElectricCar tesla = ElectricCar('Tesla Model 3', 75);
  tesla.displayInfo();
}
