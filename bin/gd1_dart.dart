// TODO 1: Định nghĩa class Vehicle với các thuộc tính String brand, int year.
// Viết Default constructor và hàm void startEngine().
class Vehicle {
  String brand;
  int year;

  // Default constructor của Vehicle
  Vehicle(this.brand, this.year);

  // Hàm void startEngine()
  void startEngine() {
    print('Khởi động phương tiện...');
  }
}

// TODO 2: Định nghĩa class Car kế thừa từ Vehicle.
// Thêm thuộc tính bool isElectric.
class Car extends Vehicle {
  bool isElectric;

  // TODO 3: Viết constructor mặc định cho Car (dùng super để truyền brand và year).
  Car(super.brand, super.year, this.isElectric);

  // Viết Named Constructor: Car.tesla(int year) thiết lập sẵn brand="Tesla" và isElectric=true.
  Car.tesla(int year)
      : isElectric = true,
        super('Tesla', year);

  // TODO 4: Ghi đè (@override) hàm startEngine() để in ra thông báo chi tiết hơn.
  @override
  void startEngine() {
    if (isElectric) {
      print('[$brand - $year] Động cơ điện khởi động: Êm ái, không tiếng ồn (Zero Emission)!');
    } else {
      print('[$brand - $year] Động cơ xăng khởi động: Vroom vroom!');
    }
  }
}

void main() {
  print('============================================================');
  print('  BÀI TẬP GIAI ĐOẠN 1: THIẾT KẾ HỆ THỐNG PHƯƠNG TIỆN GIAO THÔNG');
  print('============================================================\n');

  // TODO 5: Khởi tạo một xe Car bình thường và gọi startEngine()
  print('--- 1. Khởi tạo xe ô tô thông thường (Xe xăng) ---');
  Car normalCar = Car('Toyota Camry', 2022, false);
  print('Thông tin xe: Hãng = ${normalCar.brand}, Năm SX = ${normalCar.year}, Xe điện = ${normalCar.isElectric}');
  normalCar.startEngine();

  print('');

  // TODO 6: Khởi tạo một xe Car bằng Named Constructor (Car.tesla) và gọi startEngine()
  print('--- 2. Khởi tạo xe bằng Named Constructor (Car.tesla) ---');
  Car teslaCar = Car.tesla(2024);
  print('Thông tin xe: Hãng = ${teslaCar.brand}, Năm SX = ${teslaCar.year}, Xe điện = ${teslaCar.isElectric}');
  teslaCar.startEngine();

  print('\n============================================================');
  print('                           End                                ');
  print('============================================================');
}
