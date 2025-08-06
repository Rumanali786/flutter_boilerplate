import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:translator_app/presentation/app/controller/app_controller.dart';
import 'package:translator_app/presentation/splash/controller/splash_controller.dart';
import 'package:translator_app/utils/extensions/media_query_extensions.dart';
import 'package:translator_app/utils/extensions/sized_box_extension.dart';
import 'package:translator_app/utils/extensions/text_theme_extensions.dart';
import 'package:translator_app/utils/generated_assets/assets.dart';
import 'package:translator_app/utils/theme/light_theme.dart';

import '../../../utils/constants/colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final splashController = Get.find<SplashController>();

  @override
  void initState() {
    splashController.navigateToNext(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                Assets.imagesLogo,
                height: 140,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Adzspec Technologies",
                style: context.bodyLarge?.copyWith(color: AppColors.blackColor, fontWeight: FontWeight.w600),
              ),
              30.h,
            ],
          )
        ],
      ),
    );
  }
}
