import 'package:product_management_getx/data/models/base_response_list.dart';
import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/providers/dio_client.dart';
import 'package:product_management_getx/data/models/base_response.dart';

class ProductService {
  final _client = DioClient();

  /// Hàm gọi APIs lấy danh sách sản phẩm
  Future<List<Product>> fetchProducts(int page, int size) async {
    final res = await _client.dio.get(
      '/products',
      queryParameters: {'page': page, 'size': size},
    );
    final baseResponse = BaseResponseList<Product>.fromJson(
      res.data as Map<String, dynamic>,
      (e) => Product.fromJson(e as Map<String, dynamic>),
    );
    if (!baseResponse.success) {
      throw Exception(
        baseResponse.message ?? 'Lấy danh sách sản phẩm thất bại',
      );
    }
    return baseResponse.data ?? [];
  }

  /// Hàm gọi APIs lấy chi tiết product
  Future<Product> fetchProductDetail(int productId) async {
    final res = await _client.dio.get('/products/$productId');
    final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
      res.data as Map<String, dynamic>,
      (data) => data as Map<String, dynamic>,
    );
    if (!baseResponse.success) {
      throw Exception(baseResponse.message ?? 'Lấy chi tiết sản phẩm thất bại');
    }
    return Product.fromJson(baseResponse.data!);
  }

  /// Hàm gọi APIs xóa product
  Future<void> deleteProduct(int productId) async {
    final res = await _client.dio.delete('/products/$productId');
    final baseResponse = BaseResponse<dynamic>.fromJson(
      res.data as Map<String, dynamic>,
      (data) => data,
    );
    if (!baseResponse.success) {
      throw Exception(baseResponse.message ?? 'Xóa sản phẩm thất bại');
    }
  }

  /// Tạo mới một sản phẩm
  Future<Product> createProduct(Product product) async {
    try {
      final res = await _client.dio.post('/products', data: product.toJson());
      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        res.data as Map<String, dynamic>,
        (data) => data as Map<String, dynamic>,
      );
      if (!baseResponse.success) {
        throw Exception(baseResponse.message ?? 'Tạo sản phẩm thất bại');
      }
      return Product.fromJson(baseResponse.data!);
    } catch (e) {
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
      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        res.data as Map<String, dynamic>,
        (data) => data as Map<String, dynamic>,
      );
      if (!baseResponse.success) {
        throw Exception(baseResponse.message ?? 'Cập nhật sản phẩm thất bại');
      }
      return Product.fromJson(baseResponse.data!);
    } catch (e) {
      rethrow;
    }
  }
}
