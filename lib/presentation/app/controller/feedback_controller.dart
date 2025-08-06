import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:plant_ai/utils/extensions/sized_box_extension.dart';
import 'package:plant_ai/utils/extensions/text_theme_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/cache_client/local_db.dart';
import '../../../utils/constants/app_strings.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/generated_assets/assets.dart';
import '../../../utils/widgets/custom_rounded_button.dart';

class FeedbackController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt userFeedbackInterval = 2.obs;

  final InAppReview inAppReview = InAppReview.instance;

  void showFeedbackPrompt() {
    final RxInt selectedRating = 1.obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      remindMeLater();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              Image.asset(Assets.iconsRateUs2, height: 80),
              10.h,
              Text(
                "Your Opinion Matters to us!",
                style: Get.context?.titleLarge?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              10.h,
              Text("Tell us how was your experience with ${AppStrings.appName}?", textAlign: TextAlign.center),
              10.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating.value ? Icons.star_rounded : Icons.star_border_rounded,
                      color: index < selectedRating.value ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      selectedRating.value = index + 1;
                    },
                  );
                }),
              ),
              20.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomRoundedButton(
                    buttonWidth: 120,
                    text: 'Rate us'.tr,
                    positiveClosure: () {
                      if (selectedRating.value == 0) {
                        Get.snackbar('Feedback', 'Please select a star rating first.');
                        return;
                      }
                      giveFeedback();
                    },
                  ),
                ],
              ),
              10.h,
              GestureDetector(
                onTap: () => neverAskAgain(),
                child: Text("Never Ask Again", style: Get.context?.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkFeedbackPrompt() async {
    final feedbackGiven = LocalStorageDb.getBool('feedbackGiven');
    if (feedbackGiven) return;

    int openCount = LocalStorageDb.getInt('appOpenCount');
    openCount++;
    await LocalStorageDb.setInt('appOpenCount', openCount);

    debugPrint('App open count: $openCount');
    if (openCount % userFeedbackInterval.value == 0) {
      showFeedbackPrompt();
    }
  }

  void giveFeedback() async {
    dismissFeedbackPrompt();

    try {
      await LocalStorageDb.setBool('feedbackGiven', true);
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        final appId = Platform.isAndroid ? AppStrings.packageNameAndroid : AppStrings.appIdIos;
        final url = Uri.parse(
          Platform.isAndroid ? 'market://details?id=$appId' : 'https://apps.apple.com/app/id$appId',
        );
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      final appId = Platform.isAndroid ? AppStrings.packageNameAndroid : AppStrings.appIdIos;
      final url = Uri.parse(Platform.isAndroid ? 'market://details?id=$appId' : 'https://apps.apple.com/app/id$appId');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void remindMeLater() {
    LocalStorageDb.setInt('appOpenCount', 0);
    dismissFeedbackPrompt();
  }

  void neverAskAgain() async {
    await LocalStorageDb.setBool('feedbackGiven', true);
    dismissFeedbackPrompt();
  }

  void dismissFeedbackPrompt() async {
    Get.back();
  }
}


// // in bottom bar
// final feedbackController = Get.find<FeedbackController>();
// await feedbackController.checkFeedbackPrompt();
//
// // In setting
// feedbackController.showFeedbackPrompt();
