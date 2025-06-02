// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/app/bindings/auth_binding.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/models/user.dart';
import 'package:product_management_getx/data/dao/auth_dao.dart';
import 'package:product_management_getx/modules/auth/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive và đăng ký các Adapter
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductAdapter());

  // Mở box với kiểu dữ liệu tương ứng
  // 3. Mở box duy nhất cho Auth
  await AuthDao().init();

  if (!Hive.isBoxOpen('productCache')) {
    await Hive.openBox<Product>('productCache');
  }

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
