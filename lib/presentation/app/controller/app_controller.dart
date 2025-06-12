import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/auth_repository/models/user_model.dart';
import '../../../domain/auth_repository/repository.dart';

class AppController extends GetxController {
  Rx<UserModel> user = Rx<UserModel>(UserModel.empty);
  final authRepo = Get.find<AuthRepository>();
  RxBool isNotificationEnabled = false.obs;

  Future<void> getUserDataFromLocal() async {
    final userData = await authRepo.getUserDetail();
    if (userData != null) {
      user.value = userData;
    }
  }

  Future<void> getUserDataFromRemote() async {
    final userData = await authRepo.getUserDetailFromRemote();
    if (userData != null) {
      user.value = userData;
    }
  }



  // Future<void> updateUserToLocal() async {
  //   await authRepo.updateUser(user.value);
  //   await getUserData();
  // }

  // Load saved notification state and subscribe if first time
  Future<void> initializeNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedState = prefs.getBool('notifications');

    if (savedState == null) {
      // First time opening app → Subscribe to "dak"
      await FirebaseMessaging.instance.subscribeToTopic("dak");
      await prefs.setBool('notifications', true);
      isNotificationEnabled.value = true;
    } else {
      isNotificationEnabled.value = savedState;
    }
  }

  // Toggle notification state and handle subscription
  Future<void> toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    isNotificationEnabled.value = value;

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic("dak");
      debugPrint("Subscribed to dak");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("dak");
      debugPrint("Unsubscribed from dak");
    }

    await prefs.setBool('notifications', value);
  }
}
