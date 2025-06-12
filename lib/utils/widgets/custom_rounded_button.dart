
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/extensions/media_query_extensions.dart';
import 'package:flutter_boilerplate/utils/extensions/text_theme_extensions.dart';

import '../constants/colors.dart';
import '../constants/device_util.dart';
import '../generated_assets/assets.dart';

class CustomRoundedButton extends StatefulWidget {
  final String text;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color? textColor;
  final Color? bgColor;
  final VoidCallback positiveClosure;
  final bool? showBgImage;

  const CustomRoundedButton(
      {super.key,
      required this.text,
      this.buttonHeight = 56,
      this.buttonWidth,
      required this.positiveClosure,
      this.textColor,
      this.bgColor,
      this.showBgImage});

  @override
  State<CustomRoundedButton> createState() => _CustomRoundedButtonState();
}

class _CustomRoundedButtonState extends State<CustomRoundedButton> {
  @override
  Widget build(BuildContext context) {
    final double height = DeviceUtils.useMobileLayout(context) ? widget.buttonHeight! : widget.buttonHeight! + 10;
     return InkWell(
      onTap: () {
        widget.positiveClosure.call();
      },
      child: Container(
          height: height,
          width: widget.buttonWidth ?? context.screenWidth / 1.3,
          decoration: ShapeDecoration(
              color: widget.bgColor ?? AppColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              image: widget.showBgImage == null || widget.showBgImage == true
                  ? DecorationImage(image: AssetImage(Assets.imagesButtonBg), fit: BoxFit.cover)
                  : null),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: context.titleMedium?.copyWith(
                color: widget.textColor ?? AppColors.whiteColor,
              ),
            ),
          )),
    );
  }
}

