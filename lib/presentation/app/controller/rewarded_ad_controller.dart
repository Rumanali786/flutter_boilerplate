import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator_app/presentation/app/controller/subscription_controller.dart';
import 'package:translator_app/presentation/app/services/internet_checker_service.dart';

import '../../../utils/constants/ad_units_id.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/extensions/analytics_event_extension.dart';

class RewardedAdController extends GetxController {
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;

  RxInt userAdInterval = 3.obs;
  RxInt userLocalClicks = 0.obs;

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final subscriptionController = Get.find<SubscriptionController>();

  void initFunction() {
    int interval = remoteConfig.getInt("user_ad_interval");
    userAdInterval.value = interval == 0 ? 3 : interval;
  }

  Future<void> loadRewardedAd({required Function() onRewarded}) async {
    if (subscriptionController.isSubscribed.value) {
      onRewarded();
      return;
    }

    final hasInternet = await InternetCheckerClass.checkInternetStatus();
    if (!hasInternet) {
      hitFirebaseEvent("rewarded_no_internet");
      onRewarded();
      return;
    }

    userLocalClicks++;

    // if (userLocalClicks.value < userAdInterval.value || _isAdLoading) {
    //   hitFirebaseEvent("rewarded_skip_interval");
    //   onRewarded();
    //   return;
    // }

    _isAdLoading = true;
    Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.whiteColor,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text("Ad is Loading...".tr),
            ],
          ),
        ),
      ),
    );

    hitFirebaseEvent("rewarded_load");

    bool _hasEarnedReward = false;

    RewardedAd.load(
      adUnitId: AdUnitsId.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint("ad loaded");
          _rewardedAd = ad;
          Get.back(); // close dialog
          hitFirebaseEvent("rewarded_loaded");

          _hasEarnedReward = false; // reset before showing

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              hitFirebaseEvent("rewarded_show_full_screen");
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
            },
            onAdDismissedFullScreenContent: (ad) {
              hitFirebaseEvent("rewarded_dismissed_full_screen");
              SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.manual, overlays: SystemUiOverlay.values);
              ad.dispose();
              _rewardedAd = null;
              _isAdLoading = false;
              userLocalClicks.value = 0;

              if (_hasEarnedReward) {
                onRewarded(); // ✅ deliver reward only if earned
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              hitFirebaseEvent("rewarded_failed_to_show_full");
              logAdErrorToCrashlytics(
                error: error,
                reason: 'RewardedAd failed to show full screen',
                customData: {
                  'adType': 'rewarded',
                  'location': 'FullScreenCallback',
                },
              );
              ad.dispose();
              _rewardedAd = null;
              _isAdLoading = false;
              userLocalClicks.value = 0;
              Get.back(); // close loading dialog
              // fallback option if ad fails
              onRewarded(); // optional fallback
            },
          );

          _rewardedAd!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              hitFirebaseEvent("rewarded_earned_reward");
              _hasEarnedReward = true; // ✅ mark that reward is earned
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint("rewarded_failed_to_load");
          debugPrint(error.toString());

          hitFirebaseEvent("rewarded_failed_to_load");
          logAdErrorToCrashlytics(
            error: error,
            reason: 'RewardedAd failed to load',
            customData: {
              'adType': 'rewarded',
              'location': 'AdLoadCallback',
            },
          );
          _rewardedAd = null;
          _isAdLoading = false;
          userLocalClicks.value = 0;
          Get.back(); // close loading dialog
          onRewarded(); // optional fallback
        },
      ),
    );

  }

  @override
  void onClose() {
    _rewardedAd?.dispose();
    super.onClose();
  }
}
