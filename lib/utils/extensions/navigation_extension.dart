import 'package:flutter/material.dart';

extension NavigationExtensions on BuildContext {
  Future<T?> push<T>(Widget child) => Navigator.of(this).push<T>(
        MaterialPageRoute(
          builder: (_) => child,
        ),
      );

  Future<T?> replace<T>(Widget child) => Navigator.of(this).pushReplacement(
        MaterialPageRoute(
          builder: (_) => child,
        ),
      );

  Future<T?> removeAndUntil<T>(Widget child) =>
      Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => child),
        (route) => false,
      );

  void pop() => Navigator.of(this).pop();
}
