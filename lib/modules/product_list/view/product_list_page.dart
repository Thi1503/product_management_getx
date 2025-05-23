import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/modules/auth/controllers/auth_controller.dart';
import 'package:product_management_getx/modules/product_details/views/product_detail_page.dart';
import 'package:product_management_getx/modules/product_form/views/product_form_page.dart';
import 'package:product_management_getx/modules/product_list/controllers/product_list_controller.dart';
import 'package:product_management_getx/modules/product_list/view/product_item.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ProductListPage extends StatelessWidget {
  final AuthController authController = Get.find();
  final ProductListController productController = Get.put(
    ProductListController(),
  );
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  ProductListPage({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        productController.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value &&
            productController.products.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        int itemCount =
            productController.products.length +
            (productController.isLoadMore.value ? 1 : 0);

        return SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          onRefresh: () async {
            await productController.refresh();
            refreshController.refreshCompleted();
          },
          child: GridView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index < productController.products.length) {
                final product = productController.products[index];
                return ProductItem(
                  product: product,
                  onTap: () async {
                    await Get.to(
                      () => ProductDetailPage(productId: product.id),
                    );
                    productController.refresh();
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => ProductFormPage());
          productController.refresh();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
