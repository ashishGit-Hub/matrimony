class ApiResponse<T> {
  final bool status;
  final T? data;
  final String message;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.status,
    this.data,
    this.message = '',
    this.errors,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json.containsKey('data') && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      errors: json['errors'],
    );
  }
}
