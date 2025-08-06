import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:translator_app/presentation/app/controller/subscription_controller.dart';

import '../../../utils/constants/ad_units_id.dart';
import '../../../utils/extensions/analytics_event_extension.dart';
import '../services/internet_checker_service.dart';

class NativeAdController extends GetxController {
  NativeAd? nativeAd;
  RxBool isAdLoaded = false.obs;
  RxBool hasError = false.obs;


  Timer? _adReloadTimer;

  Future<void> loadNativeAd({TemplateType? templateType}) async {
    debugPrint("native ad loaded");
    isAdLoaded.value = false;
    hasError.value = false;
    nativeAd?.dispose();
    nativeAd = null;

    final result = await InternetCheckerClass.checkInternetStatus();
    if (!result) {
      hasError.value = true;
      return;
    }

    nativeAd = NativeAd(
      adUnitId: AdUnitsId.nativeAdUnit,
      request: const AdRequest(),
       nativeTemplateStyle: NativeTemplateStyle(templateType: templateType ?? TemplateType.medium),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          isAdLoaded.value = true;
          hasError.value = false;
          hitFirebaseEvent("native_loaded");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isAdLoaded.value = false;
          hasError.value = true;
          hitFirebaseEvent("native_failed_to_load");
          debugPrint(error.toString());

          logAdErrorToCrashlytics(
            error: error,
            reason: 'Native Template Ad failed to load',
            customData: {
              'adType': 'native_template',
              'location': 'onAdFailedToLoad',
            },
          );
        },
      ),
    );

    nativeAd!.load();

    _adReloadTimer?.cancel();
    _adReloadTimer = Timer.periodic(
        const Duration(seconds: 60), (_) => loadNativeAd(templateType: templateType ?? TemplateType.medium));
  }

  @override
  void onClose() {
    nativeAd?.dispose();
    _adReloadTimer?.cancel();
    super.onClose();
  }
}
