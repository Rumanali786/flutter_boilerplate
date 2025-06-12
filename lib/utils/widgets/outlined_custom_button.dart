
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/extensions/media_query_extensions.dart';
import 'package:flutter_boilerplate/utils/extensions/text_theme_extensions.dart';

class OutlinedCustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color borderColor;
  final Color? bgColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? fontSize;
  final VoidCallback positiveClosure;

  const OutlinedCustomButton({
    super.key,
    required this.text,
    this.buttonHeight,
    this.buttonWidth,
    required this.positiveClosure,
    required this.textColor,
    required this.borderColor,
    this.fontSize,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: positiveClosure,
      child: Container(
        height: buttonHeight ?? 56,
        width: buttonWidth ?? context.screenWidth / 1.3,
        decoration: ShapeDecoration(
          color: bgColor??Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: context.titleMedium?.copyWith(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
