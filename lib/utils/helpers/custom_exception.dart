class CustomException implements Exception {
  const CustomException([
    this.message = 'Something went wrong, please try again later.',
    this.prefix = '',
  ]);

  final String? message;
  final String? prefix;

  @override
  String toString() => (prefix ?? '') + (message ?? '');
}
