import 'package:product_management_getx/data/models/user.dart';
import 'package:product_management_getx/data/providers/dio_client.dart';
import 'package:product_management_getx/data/models/base_response.dart';

class AuthService {
  final DioClient _client = DioClient();

  Future<User> login(int taxCode, String username, String password) async {
    try {
      final res = await _client.dio.post(
        '/login2',
        data: {'tax_code': taxCode, 'user_name': username, 'password': password},
      );

      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        res.data as Map<String, dynamic>,
        (data) => data as Map<String, dynamic>,
      );

      if (!baseResponse.success) {
        throw Exception(baseResponse.message ?? 'Login thất bại');
      }

      final token = baseResponse.data?['token'] as String?;
      if (token == null) {
        throw Exception('Dữ liệu trả về không hợp lệ');
      }

      return User(
        taxCode: taxCode,
        username: username,
        accessToken: token,
      );
    } catch (e) {
      rethrow;
    }
  }
}
