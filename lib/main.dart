// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management_getx/app/bindings/auth_binding.dart';
import 'package:product_management_getx/modules/auth/views/login_page.dart';
import 'package:product_management_getx/app/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
