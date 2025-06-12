
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/utils/extensions/text_theme_extensions.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.label,
    required this.textInputType,
    super.key,
    this.hint = '',
    this.margin,
    this.controller,
    this.onChanged,
    this.radius = 10.0,
    this.isObscure = false,
    this.suffixIcon,
    this.onSuffixClick,
    this.prefixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.height = 55,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.onSubmit,
    this.inputFormatters,
    this.isSearch = false,
    this.color = const Color(0xFFF5F5F5),
    this.borderColor = AppColors.greyColor,
    this.onTap,
    this.validator,
  });

  final EdgeInsetsGeometry? margin;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final String hint;
  final double height;
  final int maxLines;
  final TextInputType textInputType;
  final bool isSearch;
  final double radius;
  final TextInputAction textInputAction;
  final bool isObscure;
  final bool readOnly;
  final bool enabled;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(String)? onSubmit;
  final void Function()? onSuffixClick;
  final List<TextInputFormatter>? inputFormatters;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // height: height,
      // alignment: Alignment.center,
      margin: margin == EdgeInsets.zero
          ? null
          : const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(radius),
      //   color: color,
      // ),
      child: TextFormField(
        onFieldSubmitted: onSubmit,
        maxLines: maxLines,
        readOnly: readOnly,
        enabled: enabled,
        obscureText: isObscure,
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        validator: validator,
        textInputAction: textInputAction,
        style: context.titleLarge?.copyWith(
            color: AppColors.blackColor,
            fontFamily: FontFamily.gillSansStdFontFamily,
            fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          isDense: true,
          fillColor: color,
          filled: true,
          floatingLabelBehavior: isSearch ? FloatingLabelBehavior.never : FloatingLabelBehavior.always,
          // contentPadding: const EdgeInsets.symmetric(
          //   vertical: 12,
          //   horizontal: 12,
          // ),
          suffixIconConstraints: const BoxConstraints(
            maxWidth: 50,
            maxHeight: 40,
          ),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: () => onSuffixClick?.call(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: suffixIcon,
                  ),
                )
              : const SizedBox(width: 15),
          labelText: label,
          hintText: hint,
          labelStyle: context.titleMedium?.copyWith(
              color: AppColors.greyColor1,
              fontFamily: FontFamily.gillSansStdFontFamily,
              fontWeight: FontWeight.normal),
          hintStyle: context.titleMedium?.copyWith(
              color: AppColors.greyColor1,
              fontFamily: FontFamily.gillSansStdFontFamily,
              fontWeight: FontWeight.normal),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
