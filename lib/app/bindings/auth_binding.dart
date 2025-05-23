import 'package:get/get.dart';
import 'package:product_management_getx/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy khởi tạo khi cần dùng lần đầu
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
