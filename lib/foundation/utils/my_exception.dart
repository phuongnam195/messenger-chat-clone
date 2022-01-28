class MyException implements Exception {
  final String message;
  final String? code;

  MyException(this.message, [this.code]);

  @override
  String toString() {
    return message;
  }
}
