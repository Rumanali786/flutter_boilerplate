import 'package:flutter/material.dart';

extension SizedBoxExtension on int {
  Widget get h => SizedBox(height: toDouble());

  Widget get w => SizedBox(width: toDouble());
}

void genericUnFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}