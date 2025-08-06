import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator_app/utils/extensions/navigation_extension.dart';

import '../../../utils/cache_client/local_db.dart';
import '../../../utils/constants/ad_units_id.dart';
import '../../../utils/extensions/analytics_event_extension.dart';
import '../../bottom_bar/view/bottom_bar_view.dart';
import '../../onboarding/view/onboarding_view.dart';
import '../services/internet_checker_service.dart';

class OpenAppAdController extends GetxController {
  AppOpenAd? _appOpenAd;

  RxBool isLoaded = false.obs;

  AppOpenAd? get getOpenAddAd => _appOpenAd;

  Future<void> loadAppOpenAd(BuildContext context) async {

    // Skip ad loading on iOS devices
    if (Platform.isIOS) {
      hitFirebaseEvent("open_skipped_ios");
     await Future.delayed(Duration(seconds: 2, milliseconds: 200));
      if (context.mounted) navigationFunction(context);
      return;
    }


    bool result = await InternetCheckerClass.checkInternetStatus();

    if (result) {
      await AppOpenAd.load(
        adUnitId: AdUnitsId.openAppAdUnit,
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) async {
            debugPrint('AppOpenAd loaded.');
            hitFirebaseEvent("open_loaded");

            _appOpenAd = ad;
            await _appOpenAd?.show();

            _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
              hitFirebaseEvent("open_shown");
            }, onAdFailedToShowFullScreenContent: (ad, error) async {
              debugPrint('AppOpenAd failed. $error');
              hitFirebaseEvent("open_failed_to_show");
              logAdErrorToCrashlytics(
                error: error,
                reason: 'AppOpenAd failed to show fullscreen',
                customData: {
                  'adType': 'app_open',
                  'location': 'FullScreenCallback',
                },
              );

              ad.dispose();
              if (context.mounted) navigationFunction(context);

              _appOpenAd = null;
            }, onAdDismissedFullScreenContent: (ad) async {
              debugPrint('AppOpenAd dismissed.');
              hitFirebaseEvent("open_dismissed");
              if (context.mounted) navigationFunction(context);

              _appOpenAd = null;
            });
          },
          onAdFailedToLoad: (error) {
            debugPrint('AppOpenAd failed to load: $error');
            hitFirebaseEvent('open_failed_to_load');
            logAdErrorToCrashlytics(
              error: error,
              reason: 'AppOpenAd failed to load',
              customData: {
                'adType': 'app_open',
                'location': 'AdLoadCallback',
              },
            );
            if (context.mounted) navigationFunction(context);
          },
        ),
        request: const AdRequest(),
      );
    } else {
      hitFirebaseEvent("open_no_internet");
      if (context.mounted) navigationFunction(context);
    }
  }

  void navigationFunction(BuildContext context) {
    final isShowedOnboarding = LocalStorageDb.getBool('isShowedOnboarding');
    if (isShowedOnboarding) {
      if (context.mounted) context.replace(BottomBarView());
    } else {
      if (context.mounted) context.replace(OnBoardingPage());
    }
  }
}

// | Event Name                   | Trigger                          |
// | ---------------------------- | -------------------------------- |
// | `open_loaded`         | When ad is successfully loaded   |
// | `open_shown`          | When ad is displayed             |
// | `open_dismissed`      | When ad is closed by the user    |
// | `open_failed_to_load` | When ad fails to load            |
// | `open_failed_to_show` | When ad fails to show fullscreen |
// | `open_no_internet`    | When no internet is available    |
