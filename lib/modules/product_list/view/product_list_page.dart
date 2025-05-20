import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/modules/auth/controllers/auth_controller.dart';
import 'package:product_management_getx/modules/product_details/views/product_detail_page.dart';
import 'package:product_management_getx/modules/product_list/controllers/product_list_controller.dart';

class ProductListPage extends StatelessWidget {
  final AuthController authController = Get.find();
  final ProductListController productController = Get.put(
    ProductListController(),
  );

  final ScrollController scrollController = ScrollController();

  ProductListPage({Key? key}) : super(key: key) {
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

        return RefreshIndicator(
          onRefresh: () async {
            productController.refresh();
            return;
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
                return InkWell(
                  onTap: () {
                    Get.to(() => ProductDetailPage(product: product));
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:
                              product.cover != null
                                  ? Image.network(
                                    product.cover!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                  : Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.image, size: 40),
                                    ),
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name ?? 'No Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Giá: ${product.price?.toStringAsFixed(0) ?? '0'}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Số lượng: ${product.quantity ?? 0}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      }),
    );
  }
}
