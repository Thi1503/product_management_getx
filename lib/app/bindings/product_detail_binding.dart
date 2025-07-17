import 'package:get/get.dart';
import 'package:product_management_getx/modules/product_details/controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    // chỉ tạo 1 lần, không tạo lại ở mỗi build
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(Get.arguments as int),
    );
  }
}
