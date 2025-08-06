import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator_app/presentation/app/controller/subscription_controller.dart';
import 'package:translator_app/presentation/app/services/internet_checker_service.dart';

import '../../../utils/constants/ad_units_id.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/extensions/analytics_event_extension.dart';

class InterstitialController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  RxInt userAdInterval = 3.obs;
  RxInt userLocalClicks = 0.obs;

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final subscriptionController = Get.find<SubscriptionController>();

  void initFunction() {
    int interval = remoteConfig.getInt("user_ad_interval");
    userAdInterval.value = interval == 0 ? 3 : interval;
  }


  Future<void> loadInterstitialAd({required Function() onSuccess}) async {
    if (subscriptionController.isSubscribed.value) {
      onSuccess();
      return;
    }

    if(Platform.isIOS){
      onSuccess();
      return;
    }

    final hasInternet = await InternetCheckerClass.checkInternetStatus();
    if (!hasInternet) {
      hitFirebaseEvent("interstitial_no_internet");

      onSuccess();
      return;
    }

    userLocalClicks++;

    if (userLocalClicks.value < userAdInterval.value || _isAdLoading) {
      hitFirebaseEvent("interstitial_skip_interval");

      onSuccess();
      return;
    }

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

    hitFirebaseEvent("interstitial_load");

    InterstitialAd.load(
      adUnitId: AdUnitsId.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          _interstitialAd = ad;
          Get.back(); // close dialog

          hitFirebaseEvent("interstitial_loaded");

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              hitFirebaseEvent("interstitial_show_full_screen");
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
            },
            onAdDismissedFullScreenContent: (ad) {
              hitFirebaseEvent("interstitial_dismissed_full_screen");
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
              ad.dispose();
              _interstitialAd = null;
              userLocalClicks.value = 0;
              _isAdLoading = false;
              onSuccess();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              hitFirebaseEvent("interstitial_failed_to_show_full");
              logAdErrorToCrashlytics(
                error: error,
                reason: 'InterstitialAd failed to show full screen',
                customData: {
                  'adType': 'interstitial',
                  'location': 'FullScreenCallback',
                },
              );
              ad.dispose();
              _interstitialAd = null;
              _isAdLoading = false;
              userLocalClicks.value = 0;
              Get.back(); // ensure dialog is closed
              onSuccess();
            },
          );

          await _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          hitFirebaseEvent("interstitial_failed_to_load");
          logAdErrorToCrashlytics(
            error: error,
            reason: 'InterstitialAd failed to load',
            customData: {
              'adType': 'interstitial',
              'location': 'AdLoadCallback',
            },
          );
          _interstitialAd = null;
          _isAdLoading = false;
          userLocalClicks.value = 0;
          Get.back();
          onSuccess();
        },
      ),
    );
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}

// | Event Name                                           | Trigger                                       |
// | ---------------------------------------------------- | --------------------------------------------- |
// | `interstitial_no_internet`                        | No internet available                         |
// | `interstitial_skip_interval` | Skipped due to click interval or loading flag |
// | `interstitial_load`                               | Ad load initiated                             |
// | `interstitial_loaded`                             | Ad successfully loaded                        |
// | `interstitial_failed_to_load`                     | Ad failed to load                             |
// | `interstitial_show_full_screen`                   | Ad shown fullscreen                           |
// | `interstitial_failed_to_show_full`                | Ad failed to show fullscreen                  |
// | `interstitial_dismissed_full_screen`              | Ad was dismissed by user                      |
