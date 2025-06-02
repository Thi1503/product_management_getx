import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/services/product_service.dart';

class ProductDetailController extends GetxController {
  final int productId;
  final product = Rxn<Product>();
  final isLoading = false.obs;

  final ProductService _service = ProductService();

  late Box<Product> _productBox;

  ProductDetailController(this.productId);

  @override
  void onInit() {
    super.onInit();
    _initHiveAndLoad();
  }

  /// Khởi tạo Hive box và load dữ liệu cache, sau đó fetch dữ liệu mới từ API
  Future<void> _initHiveAndLoad() async {
    try {
      // Mở box (nếu đã mở thì Hive sẽ trả về box hiện tại)
      _productBox = await Hive.openBox<Product>('productCache');

      // Load dữ liệu cached nếu có
      _loadCache();

      // Gọi API lấy dữ liệu mới, cập nhật cache và UI
      await fetchProduct();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể mở cache sản phẩm');
    }
  }

  /// Load dữ liệu sản phẩm từ cache (nếu có)
  void _loadCache() {
    final cachedProduct = _productBox.get(productId);
    if (cachedProduct != null) {
      product.value = cachedProduct;
    }
  }

  /// Gọi API lấy chi tiết sản phẩm, cập nhật cache và UI
  Future<void> fetchProduct() async {
    isLoading.value = true;
    try {
      final fetched = await _service.fetchProductDetail(productId);
      product.value = fetched;

      // Cập nhật cache Hive
      await _productBox.put(productId, fetched);
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

      // Xóa cache sản phẩm trong Hive
      await _productBox.delete(productId);

      Get.snackbar('Thành công', 'Đã xóa sản phẩm');
    } catch (e) {
      Get.snackbar('Lỗi', 'Xóa sản phẩm thất bại');
    } finally {
      isLoading.value = false;
    }
  }
}
