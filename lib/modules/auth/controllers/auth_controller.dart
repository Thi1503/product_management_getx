import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/data/models/user.dart';
import 'package:product_management_getx/data/services/auth_service.dart';
import 'package:product_management_getx/modules/auth/views/login_page.dart';
import 'package:product_management_getx/modules/product_list/view/product_list_page.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  // Text controllers
  final taxCodeController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Rx state
  var isLoading = false.obs;
  var isValidInput = false.obs;
  var submitted = false.obs;

  // Hive box để lưu user
  late Box<User> authBox;

  // Service
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    authBox = Hive.box<User>('authBox');
    // chỉ prefill taxCode/username, không điều hướng ở đây
    final saved = authBox.isNotEmpty ? authBox.get('user') : null;
    if (saved != null) {
      taxCodeController.text = saved.taxCode.toString();
      usernameController.text = saved.username;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // sau khi widget tree đã mount xong, mới điều hướng nếu có token
    final saved = authBox.isNotEmpty ? authBox.get('user') : null;
    if (saved != null && saved.accessToken.isNotEmpty) {
      Get.offAll(ProductListPage());
    }
  }

  /// Đăng nhập
  Future<void> login() async {
    if (!submitted.value) submitted.value = true;
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        final taxCodeStr = taxCodeController.text.trim();
        final taxCode = int.tryParse(taxCodeStr);
        if (taxCode == null) {
          throw Exception('Mã số thuế phải là số');
        }
        final username = usernameController.text.trim();
        final password = passwordController.text.trim();

        final user = await _authService.login(taxCode, username, password);

        // lưu vào Hive (xóa hết rồi add mới) - dùng key 'user' duy nhất
        await authBox.put('user', user);

        // điều hướng sang ProductList
        Get.offAll(() => ProductListPage());
        passwordController.clear();
        submitted.value = false;
      } catch (err) {
        Get.snackbar(
          'Đăng nhập thất bại',
          'Thông tin đăng nhập không chính xác',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Đăng xuất
  void logout() async {
    final saved = authBox.get('user');
    if (saved != null) {
      await authBox.put(
        'user',
        User(taxCode: saved.taxCode, username: saved.username, accessToken: ''),
      );
    }
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
