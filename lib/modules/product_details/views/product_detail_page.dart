import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/app/route.dart';
import 'package:product_management_getx/modules/product_details/controllers/product_detai_controller.dart';
import 'package:product_management_getx/modules/product_list/controllers/product_list_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController(productId));

    // void _confirmDelete() {
    //   final controller = Get.find<ProductDetailController>();
    //   if (controller.isLoading.value) return;

    //   Get.defaultDialog(
    //     title: 'Xác nhận',
    //     middleText: 'Bạn có chắc muốn xóa sản phẩm này không?',
    //     textCancel: 'Hủy',
    //     textConfirm: 'Xóa',
    //     confirmTextColor: Colors.white,
    //     onConfirm: () async {
    //       Get.back(); // đóng dialog

    //       try {
    //         await controller.deleteProduct();

    //         // Sau khi xóa thành công mới pop màn hình detail và trả về true
    //         Get.back(result: true);
    //       } catch (e) {
    //         Get.snackbar('Lỗi', 'Xóa sản phẩm thất bại');
    //       }
    //     },
    //   );
    // }

    void _deleteProduct() async {
      if (controller.isLoading.value) return;

      try {
        await controller.deleteProduct();

        // Sau khi xóa thành công, quay lại màn hình danh sách
        Get.back(result: true);
      } catch (e) {
        Get.snackbar('Lỗi', 'Xóa sản phẩm thất bại');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final name = controller.product.value?.name ?? 'Loading...';
          return Text(name);
        }),
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
        onPressed: () => _deleteProduct(),
        child: const Icon(Icons.delete, color: Colors.red),
        backgroundColor: Colors.white,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
