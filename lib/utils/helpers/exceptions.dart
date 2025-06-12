import 'custom_exception.dart';

class NoInternetException extends CustomException {
  const NoInternetException([
    super.message = 'Please check your internet and try again later.',
  ]);
}

class RequestTimeoutException extends CustomException {
  const RequestTimeoutException([
    super.message = 'Please check your internet and try again later.',
  ]);
}

class UnauthorizedException extends CustomException {
  const UnauthorizedException([super.message = null]);
}

class NotFoundException extends CustomException {
  const NotFoundException([String? message]) : super(message, 'Not Found: ');
}

class DefaultException extends CustomException {
  const DefaultException([
    super.message = 'Something went wrong, please try again later.',
  ]);
}

class EmptyCacheException extends CustomException {
  const EmptyCacheException([
    super.message = 'Something went wrong, please try again later.',
  ]);
}
