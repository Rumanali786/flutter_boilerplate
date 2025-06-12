import 'package:flutter/material.dart';

extension MediaQueryExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  double get screenAspectRatio => screenSize.aspectRatio;

  double get screenPaddingTop => MediaQuery.of(this).padding.top;


  double get screenPaddingBottom => MediaQuery.of(this).padding.bottom;

  double get screenPaddingLeft => MediaQuery.of(this).padding.left;

  double get screenPaddingRight => MediaQuery.of(this).padding.right;

  double get screenSafeAreaHeight => screenHeight - screenPaddingTop - screenPaddingBottom;

  double get screenSafeAreaWidth => screenWidth - screenPaddingLeft - screenPaddingRight;
}