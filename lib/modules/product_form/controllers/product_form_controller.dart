// lib/modules/product_form/controllers/product_form_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/services/product_service.dart';

class ProductFormController extends GetxController {
  final int? productId = Get.arguments as int?;

  // Service
  final ProductService _service = ProductService();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController coverController;

  // State
  var isEditing = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    priceController = TextEditingController();
    quantityController = TextEditingController();
    coverController = TextEditingController();

    if (productId != null) {
      isEditing.value = true;
      _loadProduct();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    coverController.dispose();
    super.onClose();
  }

  Future<void> _loadProduct() async {
    try {
      isLoading.value = true;
      final product = await _service.fetchProductDetail(productId!);
      nameController.text = product.name;
      priceController.text = product.price.toString();
      quantityController.text = product.quantity.toString();
      coverController.text = product.cover;
    } catch (e) {
      Get.snackbar('Lỗi', 'Tải thông tin sản phẩm thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProduct() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final name = nameController.text.trim();
    final price = int.tryParse(priceController.text) ?? 0;
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final cover = coverController.text.trim();

    try {
      isLoading.value = true;
      if (isEditing.value && productId != null) {
        final updated = Product(
          id: productId!,
          name: name,
          price: price,
          quantity: quantity,
          cover: cover,
        );
        await _service.updateProduct(updated);
      } else {
        final newProduct = Product(
          id: 0,
          name: name,
          price: price,
          quantity: quantity,
          cover: cover,
        );
        await _service.createProduct(newProduct);
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Lỗi', 'Lưu sản phẩm thất bại');
    } finally {
      isLoading.value = false;
    }
  }
}
