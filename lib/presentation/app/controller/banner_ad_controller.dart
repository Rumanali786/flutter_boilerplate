import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator_app/presentation/app/controller/subscription_controller.dart';

import '../../../utils/constants/ad_units_id.dart';
import '../../../utils/extensions/analytics_event_extension.dart';

class BannerAdController extends GetxController {
  late BannerAd bannerAd;
  var isBannerAdReady = false.obs;
  var isBannerFailed = false.obs;
  final subscriptionController = Get.find<SubscriptionController>();


  @override
  void onInit() {
    super.onInit();
    if(!subscriptionController.isSubscribed.value){
      _initBannerAd();
    }

  }


  void _initBannerAd() {
    // if (Platform.isIOS) {
    //   hitFirebaseEvent("banner_skipped_ios");
    //   return;
    // }
    bannerAd = BannerAd(
      adUnitId: AdUnitsId.bannerAdUnit,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAdReady.value = true;
          hitFirebaseEvent("banner_loaded");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isBannerFailed.value = true;
          hitFirebaseEvent("banner_failed_to_load");

          logAdErrorToCrashlytics(
            error: error,
            reason: 'BannerAd failed to load',
            customData: {
              'adType': 'banner',
              'location': 'onAdFailedToLoad',
            },
          );
        },
        onAdOpened: (ad) {
          hitFirebaseEvent("banner_opened");
        },
        onAdClosed: (ad) {
          hitFirebaseEvent("banner_closed");
        },
        onAdImpression: (ad) {
          hitFirebaseEvent("banner_impression");
        },
      ),
    )..load();
    hitFirebaseEvent("banner_load_started");
  }

  @override
  void onClose() {
    bannerAd.dispose();
    super.onClose();
  }
}

// | Event Name                 | Description                         |
// | -------------------------- | ----------------------------------- |
// | `banner_load_started`   | When banner ad load starts          |
// | `banner_loaded`         | Successfully loaded banner ad       |
// | `banner_failed_to_load` | Banner ad failed to load            |
// | `banner_opened`         | Banner ad is clicked                |
// | `banner_closed`         | Banner ad is closed (if applicable) |
// | `banner_impression`     | Ad impression is recorded           |
//


// final bannerAdController = Get.put(BannerAdController());
//
// @override
// void dispose() {
//   Get.delete<BannerAdController>();
//   super.dispose();
// }
//
// Obx(() {
// if (subscriptionController.isSubscribed.value) {
// return SizedBox.shrink();
// }
// if (Platform.isIOS) {
// return SizedBox.shrink();
// }
// if (bannerAdController.isBannerAdReady.value) {
// return Container(
// alignment: Alignment.center,
// width: bannerAdController.bannerAd.size.width.toDouble(),
// height: bannerAdController.bannerAd.size.height.toDouble(),
// child: AdWidget(ad: bannerAdController.bannerAd),
// );
// } else if (bannerAdController.isBannerFailed.value) {
// return SizedBox.shrink(); // or you can show an alternate widget
// } else {
// return Container(
// height: 50,
// alignment: Alignment.center,
// child: Text("Ad is loading..."),
// );
// }
// }),
