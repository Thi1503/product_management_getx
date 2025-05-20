/// User model
/// This class represents a user in the system.
class User {
  int taxCode;

  String username;

  String accessToken;
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
