// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/app/app_initializer.dart';
import 'package:product_management_getx/app/bindings/auth_binding.dart';
import 'package:product_management_getx/modules/auth/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Hive và các adapter
  // và các DAO cần thiết
  await AppInitializer.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Management',

      // 1. Đăng ký AuthController khi app khởi động
      initialBinding: AuthBinding(),

      // 2. Dùng thẳng LoginPage làm home, không cần Routes.LOGIN
      home: LoginPage(),
    );
  }
}
