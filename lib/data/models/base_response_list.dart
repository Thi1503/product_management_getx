class BaseResponseList<T> {
  final bool success;
  final String? message;
  final List<T>? data;

  BaseResponseList({required this.success, this.message, this.data});

  factory BaseResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponseList<T>(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? (json['data'] as List).map((e) => fromJsonT(e)).toList()
              : null,
    );
  }
}
