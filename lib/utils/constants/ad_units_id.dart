import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdUnitsId {
  static String get openAppAdUnit {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/3419835294' // Android Test ID
          : 'ca-app-pub-3940256099942544/5662855259'; // iOS Test ID
    } else {
      return Platform.isAndroid ? '' : '';
    }
  }

  static String get bannerAdUnit {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // Android Test ID
          : 'ca-app-pub-3940256099942544/2934735716'; // iOS Test ID
    } else {
      return Platform.isAndroid ? '' : '';
    }
  }

  static String get nativeAdUnit {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110' // Android Test ID
          : 'ca-app-pub-3940256099942544/3986624511'; // iOS Test ID
    } else {
      return Platform.isAndroid ? '' : '';
    }
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712' // Android Test ID
          : 'ca-app-pub-3940256099942544/4411468910'; // iOS Test ID
    } else {
      return Platform.isAndroid ? '' : '';
    }
  }

  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917' // Android Test ID
          : 'ca-app-pub-3940256099942544/1712485313'; // iOS Test ID
    } else {
      return Platform.isAndroid ? '' : '';
    }
  }
}
