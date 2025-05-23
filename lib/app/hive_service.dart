import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/models/user.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProductAdapter());

    if (!Hive.isBoxOpen('authBox')) {
      await Hive.openBox<User>('authBox');
    }
    if (!Hive.isBoxOpen('productCache')) {
      await Hive.openBox<Product>('productCache');
    }
  }
}
