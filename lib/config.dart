import 'dart:io';

 import 'package:purchases_flutter/purchases_flutter.dart';

const String googleApiKey = ' ';
const String geminiApiKey = ' ';

Future<void> initPlatformState() async {
  PurchasesConfiguration? configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration(" ");
  } else if (Platform.isIOS) {
    configuration = PurchasesConfiguration(" ");
  }

  await Purchases.configure(configuration!);
}