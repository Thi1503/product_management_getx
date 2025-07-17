import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/data/models/user.dart';

class AuthDao {
  // 1. Khai báo singleton
  static final AuthDao _instance = AuthDao._internal();
  factory AuthDao() => _instance;
  AuthDao._internal();

  // 2. Box của Hive để chứa User
  late Box<User> _authBox;

  /// Phương thức khởi tạo (mở box). Gọi một lần duy nhất ở main().
  Future<void> init() async {
    // Giả sử bạn đã đăng ký adapter UserAdapter() trước đó
    _authBox = await Hive.openBox<User>('authBox');
  }

  /// Lấy user (nếu có)
  User? getUser() {
    if (_authBox.isEmpty) return null;
    return _authBox.get('user');
  }

  /// Lưu user (ghi đè luôn key 'user')
  Future<void> saveUser(User user) async {
    await _authBox.put('user', user);
  }

  /// Cập nhật accessToken (giả sử khi logout, chỉ ghi lại token rỗng)
  Future<void> clearToken() async {
    final saved = getUser();
    if (saved != null) {
      final newUser = User(
        taxCode: saved.taxCode,
        username: saved.username,
        accessToken: '',
      );
      await _authBox.put('user', newUser);
    }
  }

  /// Xóa hẳn user (nếu cần)
  Future<void> deleteUser() async {
    await _authBox.delete('user');
  }
}
