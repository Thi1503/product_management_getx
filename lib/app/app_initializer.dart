import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/data/models/user.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/dao/auth_dao.dart';
import 'package:product_management_getx/data/dao/product_dao.dart';

class AppInitializer {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProductAdapter());

    await AuthDao().init();
    await ProductDao().init();
  }
}