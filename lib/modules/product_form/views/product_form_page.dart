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
        child: Form(
          key: ctrl.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: ctrl.nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.priceController,
                decoration: const InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Không được để trống';
                  if (int.tryParse(value) == null) return 'Phải là số';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.quantityController,
                decoration: const InputDecoration(labelText: 'Số lượng'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Không được để trống';
                  if (int.tryParse(value) == null) return 'Phải là số';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.coverController,
                decoration: const InputDecoration(labelText: 'URL Ảnh'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 24),
              Obx(
                () => ElevatedButton(
                  onPressed: ctrl.isLoading.value ? null : ctrl.saveProduct,
                  child: Text(ctrl.isEditing.value ? 'Cập nhật' : 'Tạo mới'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
