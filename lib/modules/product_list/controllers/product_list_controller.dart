import 'package:get/get.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/services/product_service.dart';

class ProductListController extends GetxController {
  final ProductService _service = ProductService();
  var products = <Product>[].obs;
  var page = 1.obs;
  var size = 10;
  var isLoading = false.obs;
  var isLoadMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  void fetchInitial() async {
    isLoading.value = true;
    page.value = 1;
    products.clear();
    final list = await _service.fetchProducts(1, size);
    products.assignAll(list);
    isLoading.value = false;
  }

  void loadMore() async {
    if (isLoadMore.value) return;
    isLoadMore.value = true;
    final next = await _service.fetchProducts(page.value + 1, size);
    if (next.isNotEmpty) {
      products.addAll(next);
      page.value++;
    }
    isLoadMore.value = false;
  }

  void refresh() {
    fetchInitial();
  }
}
