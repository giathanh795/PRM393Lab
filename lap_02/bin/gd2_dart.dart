// ignore_for_file: avoid_print, use_super_parameters

// =============================================================================
// GIAI ĐOẠN 2: NGÔN NGỮ DART
// Tên bài: Quản lý nhân viên với Mixin & Spread Operator
// =============================================================================

abstract class Employee {
  String name;
  Employee(this.name);
  void work();
}

// TODO 1: Khai báo mixin CheckInAbility giới hạn cho Employee
mixin CheckInAbility on Employee {
  void checkIn() {
    print('$name đã điểm danh');
  }
}

// TODO 2: Tích hợp mixin CheckInAbility vào class này
class Developer extends Employee with CheckInAbility {
  Developer(String name) : super(name);

  @override
  void work() => print('$name đang viết code.');
}

void main() {
  print('============================================================');
  print('  BÀI TẬP GIAI ĐOẠN 2: MIXIN & SPREAD OPERATOR TRONG DART  ');
  print('============================================================\n');

  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];

  print('Danh sách teamA: ${teamA.map((e) => e.name).toList()}');
  print('Danh sách teamB: ${teamB.map((e) => e.name).toList()}\n');

  // TODO 3: Dùng Spread Operator (...) để gộp teamA và teamB vào allStaff
  List<Developer> allStaff = [...teamA, ...teamB];

  print('--- Danh sách điểm danh toàn bộ nhân viên (allStaff) ---');
  // TODO 4: Dùng vòng lặp gọi hàm checkIn() cho tất cả nhân sự trong allStaff
  for (var staff in allStaff) {
    staff.checkIn();
  }

  print('\n--- Thử nghiệm gọi hàm work() của từng nhân sự ---');
  for (var staff in allStaff) {
    staff.work();
  }

  print('\n============================================================');
  print('                  HOÀN THÀNH BÀI TẬP GĐ 2                   ');
  print('============================================================');
}
