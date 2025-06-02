import 'package:get/get.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/services/product_service.dart';

class ProductListController extends GetxController {
  final ProductService _service = ProductService();
  final products = <Product>[].obs;
  var page = 1;
  final int size = 6;
  final isLoading = false.obs;
  final isLoadMore = false.obs;
  final hasMore = true.obs;

  @override
  void onReady() {
    super.onReady();
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      page = 1;
      hasMore.value = true;
      final list = await _service.fetchProducts(page, size);
      products.assignAll(list);
      if (list.length < size) hasMore.value = false;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách sản phẩm');
      print('fetchInitial error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadMore.value || !hasMore.value) return;
    try {
      isLoadMore.value = true;
      final nextPage = page + 1;
      final next = await _service.fetchProducts(nextPage, size);
      if (next.isNotEmpty) {
        products.addAll(next);
        page = nextPage;
        if (next.length < size) hasMore.value = false;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thêm sản phẩm');
      print('loadMore error: $e');
    } finally {
      isLoadMore.value = false;
    }
  }

  /// Dùng cho SmartRefresher
  Future<void> refresh() async {
    await fetchInitial();
  }
}
