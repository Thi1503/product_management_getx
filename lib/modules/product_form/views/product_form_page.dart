// lib/modules/product_form/views/product_form_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/modules/product_form/controllers/product_form_controller.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProductFormController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            ctrl.isEditing.value ? 'Cập nhật sản phẩm' : 'Tạo sản phẩm mới',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: ctrl.nameController,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl.priceController,
              decoration: const InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl.quantityController,
              decoration: const InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl.coverController,
              decoration: const InputDecoration(labelText: 'URL Ảnh'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: ctrl.saveProduct,
              child: Obx(
                () => Text(ctrl.isEditing.value ? 'Cập nhật' : 'Tạo mới'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
