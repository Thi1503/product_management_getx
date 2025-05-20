import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/modules/auth/controllers/auth_controller.dart';

class ProductListPage extends StatelessWidget {
  // Lấy instance controller đã được Binding khởi tạo
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Center(child: Text('Product List Page')),
    );
  }
}
