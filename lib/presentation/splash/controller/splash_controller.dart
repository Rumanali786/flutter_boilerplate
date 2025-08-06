import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:translator_app/presentation/app/controller/open_app_ad_controller.dart';
import 'package:translator_app/presentation/bottom_bar/view/bottom_bar_view.dart';
import 'package:translator_app/utils/cache_client/local_db.dart';
import 'package:translator_app/utils/extensions/navigation_extension.dart';

import '../../app/controller/interstitial_controller.dart';
import '../../app/controller/subscription_controller.dart';
import '../../onboarding/view/onboarding_view.dart';

class SplashController extends GetxController {
  final openAppAdController = Get.put(OpenAppAdController());
  final interstitialController = Get.find<InterstitialController>();
  final subscriptionController = Get.find<SubscriptionController>();

  void navigateToNext(BuildContext context) async {
    await MobileAds.instance.initialize();
    interstitialController.initFunction();
    if(subscriptionController.isSubscribed.value){
      openAppAdController.navigationFunction(context);
    }else{
      await openAppAdController.loadAppOpenAd(context);

    }
  }
}
