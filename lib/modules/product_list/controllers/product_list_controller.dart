import 'package:get/get.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/services/product_service.dart';

class ProductListController extends GetxController {
  final ProductService _service = ProductService();
  var products = <Product>[].obs;
  var page = 1.obs;
  final int size = 6;
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      page.value = 1;
      hasMore.value = true;
      final list = await _service.fetchProducts(page.value, size);
      products.assignAll(list);
      if (list.length < size) hasMore.value = false;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách sản phẩm');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadMore.value || !hasMore.value) return;
    try {
      isLoadMore.value = true;
      final nextPage = page.value + 1;
      final next = await _service.fetchProducts(nextPage, size);
      if (next.isNotEmpty) {
        products.addAll(next);
        page.value = nextPage;
        if (next.length < size) hasMore.value = false;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thêm sản phẩm');
    } finally {
      isLoadMore.value = false;
    }
  }

  /// Dùng cho SmartRefresher
  @override
  Future<void> refresh() async {
    await fetchInitial();
  }
}
