import 'package:get/get.dart';
import 'package:product_management_getx/data/dao/product_dao.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/services/product_service.dart';

class ProductDetailController extends GetxController {
  final int productId;
  final product = Rxn<Product>();
  final isLoading = false.obs;

  final ProductService _service = ProductService();
  final ProductDao _productDao = ProductDao();

  ProductDetailController(this.productId);

  @override
  void onInit() {
    super.onInit();
    _loadCacheThenFetch();
  }

  /// Bước 1: Load cache (nếu có) và hiển thị lên UI ngay
  /// Bước 2: Gọi API fetch chi tiết, cập nhật cache & UI
  Future<void> _loadCacheThenFetch() async {
    // 1.1 Load cache từ DAO
    final cached = _productDao.getCached(productId);
    if (cached != null) {
      product.value = cached;
    }

    // 1.2 Gọi API để lấy dữ liệu mới
    await fetchProduct();
  }

  /// Gọi API lấy chi tiết sản phẩm, cập nhật cache và UI
  Future<void> fetchProduct() async {
    isLoading.value = true;
    try {
      final fetched = await _service.fetchProductDetail(productId);
      product.value = fetched;

      // Cập nhật cache Hive qua DAO
      await _productDao.upsert(fetched);
    } catch (e) {
      Get.snackbar('Lỗi', 'Tải sản phẩm thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  /// Xóa sản phẩm (gọi API và xóa cache)
  Future<void> deleteProduct() async {
    isLoading.value = true;
    try {
      await _service.deleteProduct(productId);

      // Xóa cache sản phẩm trong Hive qua DAO
      await _productDao.delete(productId);

      Get.snackbar('Thành công', 'Đã xóa sản phẩm');
    } catch (e) {
      Get.snackbar('Lỗi', 'Xóa sản phẩm thất bại');
    } finally {
      isLoading.value = false;
    }
  }
}
