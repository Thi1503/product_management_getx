import 'package:product_management_getx/data/models/user.dart';
import 'package:product_management_getx/data/providers/dio_client.dart';

class AuthService {
  Future<User> login(String taxCode, String username, String password) async {
    final _client = DioClient();
    final res = await _client.dio.post(
      '/login2',
      data: {
        'tax_code': int.parse(taxCode),
        'user_name': username,
        'password': password,
      },
    );

    final body = res.data as Map<String, dynamic>;
    if (body['success'] != true) {
      throw Exception(body['message'] ?? 'Login thất bại');
    }

    final payload = body['data'] as Map<String, dynamic>;
    final token = payload['token'] as String;

    return User(
      // nếu User.taxCode là String thì dùng taxCode,
      taxCode: int.parse(taxCode),
      username: username,
      accessToken: token,
    );
  }
}
