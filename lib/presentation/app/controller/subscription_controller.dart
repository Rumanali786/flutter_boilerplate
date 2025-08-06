import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
 import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/cache_client/local_db.dart';

class SubscriptionController extends GetxController {
  Rx<CustomerInfo?> customerInfo = Rx<CustomerInfo?>(null);
  RxBool isSubscribed = false.obs;

  static const String _subscriptionCacheKey = 'last_known_is_subscribed';

  @override
  void onInit() {
    super.onInit();
    loadCachedSubscription(); // 👈 Load from local if offline
    fetchInitialCustomerInfo();
    initializeSubscriptionListener();
  }

  void initializeSubscriptionListener() {
    Purchases.addCustomerInfoUpdateListener((info) async {
      await _processCustomerInfo(info);
    });
  }

  Future<void> fetchInitialCustomerInfo() async {
    try {
      final info = await Purchases.getCustomerInfo();
      await _processCustomerInfo(info);
    }catch (e) {
      debugPrint('Error fetching customer info: $e');
    }
  }

  Future<void> _processCustomerInfo(CustomerInfo info) async {
    customerInfo.value = info;
    final active = info.activeSubscriptions.isNotEmpty;
    isSubscribed.value = active;
    LocalStorageDb.setBool(_subscriptionCacheKey, active);

    debugPrint('Processed info: Is subscribed: $active');
  }

  Future<void> loadCachedSubscription() async {
    final cachedStatus = LocalStorageDb.getNullBool(_subscriptionCacheKey);
    if (cachedStatus != null) {
      isSubscribed.value = cachedStatus;
      debugPrint('Loaded cached subscription status: $cachedStatus');
    }
  }

}
