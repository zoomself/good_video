class ApiResultException implements Exception{
  dynamic code;
  final dynamic message;
  ApiResultException([this.message]);

  @override
  String toString() {
    return 'ApiResultException{code: $code, message: $message}';
  }
}