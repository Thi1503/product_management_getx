import 'package:product_management_getx/data/models/product.dart';
import 'package:product_management_getx/data/providers/dio_client.dart';

class ProductService {
  final _client = DioClient();

  Future<List<Product>> fetchProducts(int page, int size) async {
    final res = await _client.dio.get(
      '/products',
      queryParameters: {'page': page, 'size': size},
    );
    return (res.data['data'] as List).map((e) => Product.fromJson(e)).toList();
  }
}
