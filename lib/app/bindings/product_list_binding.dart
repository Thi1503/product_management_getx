import 'package:get/get.dart';
import 'package:product_management_getx/modules/product_list/controllers/product_list_controller.dart';

class ProductListBinding extends Bindings {
  void dependencies() {
    // Lazy khởi tạo khi cần dùng lần đầu
    Get.lazyPut<ProductListController>(() => ProductListController());
  }
}
