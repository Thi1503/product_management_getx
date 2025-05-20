// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/app/bindings/auth_binding.dart';
import 'package:product_management_getx/app/route.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/models/user.dart';
import 'package:product_management_getx/data/models/user_adapter.dart';
import 'package:product_management_getx/data/models/product_adapter.dart';
import 'package:product_management_getx/modules/auth/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive và đăng ký các Adapter
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductAdapter());

  // Mở box với kiểu dữ liệu tương ứng
  if (!Hive.isBoxOpen('authBox')) {
    await Hive.openBox<User>('authBox');
  }
  await Hive.openBox<Product>('productCache');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Management',
      initialRoute: Routes.LOGIN, // tự động put AuthController trước route đầu
      getPages: [
        GetPage(
          name: Routes.LOGIN,
          page: () => LoginPage(),
          binding: AuthBinding(),
        ), // khởi tạo AuthController
      ],
    );
  }
}
