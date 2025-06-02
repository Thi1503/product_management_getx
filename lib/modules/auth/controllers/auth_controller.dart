import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/data/services/auth_service.dart';
import 'package:product_management_getx/data/dao/auth_dao.dart';
import 'package:product_management_getx/modules/auth/views/login_page.dart';
import 'package:product_management_getx/modules/product_list/view/product_list_page.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final taxCodeController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isValidInput = false.obs;
  final submitted = false.obs;

  // Không cần Box<User> nữa, chỉ cần DAO
  final AuthService _authService = AuthService();
  final AuthDao _authDao = AuthDao();

  @override
  void onInit() {
    super.onInit();
    // Chỉ prefill thu mã số thuế / username, không điều hướng ở đây
    final saved = _authDao.getUser();
    if (saved != null) {
      taxCodeController.text = saved.taxCode.toString();
      usernameController.text = saved.username;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Sau khi widget tree đã mount xong, mới điều hướng nếu có token
    final saved = _authDao.getUser();
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

        // Gọi service để login
        final user = await _authService.login(taxCode, username, password);

        // Lưu vào Hive thông qua AuthDao
        await _authDao.saveUser(user);

        // Điều hướng sang ProductList
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
    // Cập nhật token = '' qua DAO
    await _authDao.clearToken();
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
