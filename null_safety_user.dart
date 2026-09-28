/// Bài 1.6: Xử lý Null Safety và Khởi tạo an toàn (Factory Constructor)
///
/// Đây là ví dụ hoàn thiện yêu cầu:
/// - Định nghĩa lớp `User` với id, name (bắt buộc) và email (nullable).
/// - Factory constructor `User.fromJson` chuyển JSON sang đối tượng, dùng `??` để
///   cung cấp giá trị mặc định cho `name` nếu nó null hoặc thiếu.
/// - Phương thức `showProfile` in thông tin, dùng `??` để thay thế email null
///   bằng chuỗi "Chưa cập nhật".
/// - Hàm `main` mô phỏng dữ liệu JSON trả về từ API và tạo hai đối tượng
///   `User` để hiển thị.

class User {
  int id;
  String name;
  String? email; // nullable variable

  // Constructor
  User({required this.id, required this.name, this.email});

  // Factory constructor: parse JSON safely
  factory User.fromJson(Map<String, dynamic> json) {
    int id = json['id'] as int;
    String name = json['name'] as String? ?? "Khách";
    String? email = json['email'] as String?;
    return User(id: id, name: name, email: email);
  }

  void showProfile() {
    String emailDisplay = email ?? "Chưa cập nhật";
    print('ID: $id | Tên: $name | Email: $emailDisplay');
  }
}

void main() {
  Map<String, dynamic> rawData1 = {
    "id": 1,
    "name": "Nam",
    "email": "nam@fpt.edu.vn"
  };
  Map<String, dynamic> rawData2 = {
    "id": 2,
    "name": null,
    "email": null
  };

  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);

  user1.showProfile();
  user2.showProfile();
}
