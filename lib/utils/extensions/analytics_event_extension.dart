import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void hitFirebaseEvent(name) {
  unawaited(FirebaseAnalytics.instance.logEvent(
    name: name,
  ));
}

void logAdErrorToCrashlytics({
  required dynamic error,
  required String reason,
  StackTrace? stackTrace,
  Map<String, dynamic>? customData,
}) {
  if (!kDebugMode) {
    FirebaseCrashlytics.instance.log(reason);

    if (customData != null) {
      customData.forEach((key, value) {
        FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
      });
    }

    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace ?? StackTrace.current,
      reason: reason,
    );
  }
}
