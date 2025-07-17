import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/app/bindings/product_detail_binding.dart';
import 'package:product_management_getx/modules/auth/controllers/auth_controller.dart';
import 'package:product_management_getx/modules/product_details/views/product_detail_page.dart';
import 'package:product_management_getx/modules/product_form/views/product_form_page.dart';
import 'package:product_management_getx/modules/product_list/controllers/product_list_controller.dart';
import 'package:product_management_getx/modules/product_list/view/product_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find();
  final ProductListController productController = Get.put(
    ProductListController(),
  );
  final RefreshController refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: Obx(() {
        // Nếu đang load lần đầu và chưa có data, hiển thị spinner giữa màn hình
        if (productController.isLoading.value &&
            productController.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Số lượng item đúng bằng số products
        final itemCount = productController.products.length;

        return SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          enablePullUp: true, // bật load more
          // (Nếu muốn costumize footer có thể truyền footer: ClassicFooter(), nhưng mặc định vẫn có)
          onRefresh: () async {
            await productController.refresh();
            refreshController.refreshCompleted();
          },
          onLoading: () async {
            await productController.loadMore();
            refreshController.loadComplete();
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return ProductItem(
                product: product,
                onTap: () async {
                  final deleted = await Get.to(
                    () => const ProductDetailPage(),
                    arguments: product.id,
                    binding: ProductDetailBinding(),
                  );

                  if (deleted == true) {
                    productController.products.removeWhere(
                      (p) => p.id == product.id,
                    );
                  } else {
                    productController.refresh();
                  }
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => ProductFormPage());
          productController.refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
