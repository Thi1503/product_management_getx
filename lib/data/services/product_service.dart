import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/providers/dio_client.dart';

class ProductService {
  final _client = DioClient();

  ///Hàm gọi APIs lấy danh sách sản phẩm
  Future<List<Product>> fetchProducts(int page, int size) async {
    final res = await _client.dio.get(
      '/products',
      queryParameters: {'page': page, 'size': size},
    );
    return (res.data['data'] as List).map((e) => Product.fromJson(e)).toList();
  }

  /// Hàm gọi APIs lấy chi tiết product
  Future<Product> fetchProductDetail(int productId) async {
    final res = await _client.dio.get('/products/$productId');
    return Product.fromJson(res.data['data']);
  }

  /// Hàm gọi APIs xóa product
  Future<void> deleteProduct(int productId) async {
    await _client.dio.delete('/products/$productId');
  }

  /// Tạo mới một sản phẩm
  Future<Product> createProduct(Product product) async {
    try {
      final res = await _client.dio.post('/products', data: product.toJson());
      // Kiểm tra mã trạng thái trả về
      if (res.statusCode == 200 || res.statusCode == 201) {
        return Product.fromJson(res.data['data']);
      } else {
        throw Exception('Tạo sản phẩm thất bại (status: ${res.statusCode})');
      }
    } catch (e) {
      // Có thể log thêm hoặc xử lý lỗi chuyên sâu hơn
      rethrow;
    }
  }

  /// Cập nhật một sản phẩm đã tồn tại
  Future<Product> updateProduct(Product product) async {
    try {
      final res = await _client.dio.put(
        '/products/${product.id}',
        data: product.toJson(),
      );
      // Chỉ chấp nhận 200 OK
      if (res.statusCode == 200) {
        return Product.fromJson(res.data['data']);
      } else {
        throw Exception(
          'Cập nhật sản phẩm thất bại (status: ${res.statusCode})',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
