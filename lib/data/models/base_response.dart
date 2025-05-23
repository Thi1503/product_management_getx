class BaseResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  BaseResponse({required this.success, this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
