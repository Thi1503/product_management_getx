import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/data/models/user.dart';
import 'package:product_management_getx/data/services/auth_service.dart';
import 'package:product_management_getx/modules/auth/views/login_page.dart';
import 'package:product_management_getx/modules/product_list/view/product_list_page.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  //  Text controllers
  final taxCodeController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Rx state
  var isLoading = false.obs;
  var isValidInput = false.obs;
  var submitted = false.obs;

  // Hive box để lưu user
  late Box<User> authBox;

  //  Service
  final AuthService _authService = AuthService();

  //  Constructor
  @override
  void onInit() {
    super.onInit();
    authBox = Hive.box<User>('authBox');
    // chỉ prefill taxCode/username, không điều hướng ở đây
    final saved = authBox.getAt(0);
    if (saved != null) {
      taxCodeController.text = saved.taxCode.toString();
      usernameController.text = saved.username;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // sau khi widget tree đã mount xong, mới điều hướng nếu có token
    final saved = authBox.getAt(0);
    if (saved != null && saved.accessToken.isNotEmpty) {
      Get.offAll(ProductListPage());
    }
  }

  /// Đăng nhập
  Future<void> login() async {
    // bật autovalidate ngay khi user nhấn lần đầu
    if (!submitted.value) submitted.value = true;

    // nếu form invalid thì thôi
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        final taxCode = taxCodeController.text.trim();
        final username = usernameController.text.trim();
        final password = passwordController.text.trim();

        // gọi service
        final user = await _authService.login(taxCode, username, password);

        // lưu vào Hive (xóa hết rồi add mới)
        await authBox.put('user', user);

        // điều hướng sang ProductList
        Get.offAll(() => ProductListPage());
        // Clear form để lần sau login không còn dữ liệu cũ
        passwordController.clear();
        submitted.value = false; // nếu bạn dùng autovalidate
      } catch (err) {
        // show error
        Get.snackbar(
          // Mặc định `titleText` và `messageText` sẽ bị override nếu có, nên mình đưa hết vào đây
          '',
          '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          // Khoá các màu text chung
          colorText: Colors.red,
          // Bỏ luôn title mặc định, dùng custom Text
          titleText: Text(
            'Đăng nhập thất bại',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          messageText: Text(
            'Thông tin đăng nhập không chính xác',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
          // Tuỳ chọn thêm để nó nổi bật hơn
          borderRadius: 8,
          margin: EdgeInsets.all(16),
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(seconds: 1),
        );
      } finally {
        isLoading.value = false;
      }
    }
    ;
  }

  /// Đăng xuất
  void logout() async {
    if (authBox.isNotEmpty) {
      // read:
      final saved = authBox.get('user');
      // chỉ add lại taxCode & username, token rỗng
      await authBox.add(
        User(
          taxCode: saved!.taxCode,
          username: saved.username,
          accessToken: '',
        ),
      );
    }
    // trở về login
    Get.offAll(LoginPage());
  }

  @override
  void onClose() {
    taxCodeController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
