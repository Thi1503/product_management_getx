import 'package:hive/hive.dart';

part 'user.g.dart'; // file adapter sẽ được tạo tự động

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final int taxCode;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String accessToken;

  User({
    required this.taxCode,
    required this.username,
    required this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      taxCode: json['tax_code'] as int,
      username: json['user_name'] as String,
      accessToken: json['access_token'] as String, // ← đúng key từ server
    );
  }
}
