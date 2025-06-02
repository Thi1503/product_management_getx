// data/dao/product_dao.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management_getx/data/models/product.dart';

class ProductDao {
  // 1. Singleton
  static final ProductDao _instance = ProductDao._internal();
  factory ProductDao() => _instance;
  ProductDao._internal();

  // 2. Box để lưu cache Product
  late Box<Product> _productBox;

  /// Gọi 1 lần duy nhất ở main() để mở box
  Future<void> init() async {
    // Nếu đã register adapter ProductAdapter() trước đó thì chỉ cần mở box
    _productBox = await Hive.openBox<Product>('productCache');
  }

  /// Lấy Product từ cache, nếu không có trả về null
  Product? getCached(int id) {
    return _productBox.get(id);
  }

  /// Lưu hoặc cập nhật cache cho 1 productId
  Future<void> upsert(Product product) async {
    await _productBox.put(product.id, product);
  }

  /// Xóa cache của 1 productId
  Future<void> delete(int id) async {
    await _productBox.delete(id);
  }
}
