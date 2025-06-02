import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/modules/product_details/controllers/product_detail_controller.dart';
import 'package:product_management_getx/modules/product_form/views/product_form_page.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key}); // ❌ không cần productId nữa

  @override
  Widget build(BuildContext context) {
    Future<void> _confirmDelete() async {
      if (controller.isLoading.value) return;

      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Xóa'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await controller.deleteProduct();
        Get.back(result: true, closeOverlays: true); // trả kết quả
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.product.value?.name ?? 'Loading...')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Get.to(
                () => const ProductFormPage(),
                arguments: controller.product.value?.id,
              );
              await Future.delayed(const Duration(milliseconds: 100));
              controller.fetchProduct();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.product.value;
        if (product == null)
          return const Center(child: Text('No product data'));

        return SingleChildScrollView(
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
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                'Quantity: ${product.quantity}',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              if (controller.isLoading.value) const LinearProgressIndicator(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmDelete,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete),
      ),
    );
  }
}
