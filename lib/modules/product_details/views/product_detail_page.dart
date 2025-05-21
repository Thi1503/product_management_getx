import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/modules/product_details/controllers/product_detail_controller.dart';
import 'package:product_management_getx/modules/product_form/views/product_form_page.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController(productId));

    ///TODO: cần tối ưu và chuẩn lại
    void _confirmDelete() async {
      final controller = Get.find<ProductDetailController>();
      if (controller.isLoading.value) return;

      await Get.defaultDialog(
        title: 'Xác nhận',
        middleText: 'Bạn có chắc muốn xóa sản phẩm này không?',
        textCancel: 'Hủy',
        textConfirm: 'Xóa',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // đóng dialog

          try {
            controller.deleteProduct();

            // Sau khi xóa thành công mới pop màn hình detail và trả về true
          } catch (e) {
            Get.snackbar('Lỗi', 'Xóa sản phẩm thất bại');
          }
        },
      );
      Get.back();
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final name = controller.product.value?.name ?? 'Loading...';
          return Text(name);
        }),
        actions: [
          Obx(() {
            final product = controller.product.value;
            return IconButton(
              onPressed: () async {
                await Get.to(() => ProductFormPage(), arguments: product?.id);

                controller.fetchProduct();
              },
              icon: Icon(Icons.edit),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.product.value;

        if (product == null) {
          return const Center(child: Text('No product data'));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(product.cover),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ${product.price.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                'Quantity: ${product.quantity}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              if (controller.isLoading.value) const LinearProgressIndicator(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _confirmDelete(),
        child: const Icon(Icons.delete, color: Colors.red),
        backgroundColor: Colors.white,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
