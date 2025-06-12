import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showToast(String title,String msg) {
  Get.snackbar(
    title,
    msg,
    duration: const Duration(seconds: 2),
    // padding: EdgeInsets.only(bottom: 20),
    margin: const EdgeInsets.all(12),
    snackPosition: SnackPosition.TOP,
  );
}
