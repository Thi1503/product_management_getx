import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/services/product_service.dart';

class ProductDetailController extends GetxController {
  final int productId;
  var product = Rxn<Product>();
  var isLoading = false.obs;

  final ProductService _service = ProductService();

  late Box<Product> _productBox;

  ProductDetailController(this.productId);

  @override
  void onInit() {
    super.onInit();
    _initHiveAndLoad();
  }

  Future<void> _initHiveAndLoad() async {
    // Mở box nếu chưa mở
    if (!Hive.isBoxOpen('productCache')) {
      _productBox = await Hive.openBox<Product>('productCache');
    } else {
      _productBox = Hive.box<Product>('productCache');
    }

    // Load dữ liệu cached nếu có
    final cachedProduct = _productBox.get(productId);
    if (cachedProduct != null) {
      product.value = cachedProduct;
    }

    // Gọi API lấy dữ liệu mới, cập nhật cache và UI
    await fetchProduct();
  }

  Future<void> fetchProduct() async {
    isLoading.value = true;
    try {
      final fetched = await _service.fetchProductDetail(productId);
      product.value = fetched;

      // Cập nhật cache Hive
      await _productBox.put(productId, fetched);
    } catch (e) {
      // Có thể xử lý lỗi nếu cần
    } finally {
      isLoading.value = false;
    }
  }

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
