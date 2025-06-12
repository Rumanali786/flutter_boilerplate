import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef OnMessage = void Function(Map<String, dynamic> message);

/// Listen to background notifications.
/// It must be a top-level function to spawn an Isolate.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class CloudMessagingService {
  CloudMessagingService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? flutterLocalNotifications,
    OnMessage? messageHandler,
  })  : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _flutterLocalNotifications = flutterLocalNotifications ?? FlutterLocalNotificationsPlugin(),
        _messageHandler = messageHandler;

  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _flutterLocalNotifications;
  final OnMessage? _messageHandler;
  late final StreamSubscription<RemoteMessage> foregroundMessage;
  late final StreamSubscription<RemoteMessage> messageInteraction;

  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    await _requestPermissions();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _flutterLocalNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    foregroundMessage = _onForegroundMessage();
    _onBackgroundMessage();
    messageInteraction = await _handleMessageInteraction();
  }

  void dispose() {
    foregroundMessage.cancel();
    messageInteraction.cancel();
  }

  Future<String?> get token async {
    final response = await _firebaseMessaging.getToken();
    return response;
  }

  Future<String?> get deviceId async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
       var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      return AndroidId().getId(); // unique ID on Android
    }
    return null;
  }

  Future<bool> _requestPermissions() async {
    try {
      final response = await _firebaseMessaging.requestPermission();

      return response.authorizationStatus == AuthorizationStatus.authorized;
    } on Exception catch (e) {
      log('Error requesting permissions: $e');

      return false;
    }
  }

  /// Listen to foreground notifications
  StreamSubscription<RemoteMessage> _onForegroundMessage() {
    return FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;
        final isAndroid = Platform.isAndroid;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null && isAndroid) {
          _flutterLocalNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                // icon: android.smallIcon,
                icon: 'ic_notification',
                importance: _channel.importance,
              ),
            ),
          );
        }
        _handleMessage(message);
        log('Foreground message received, data: ${message.data}');
      },
    );
  }

  /// Listen to background notifications
  void _onBackgroundMessage() => FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

  Future<StreamSubscription<RemoteMessage>> _handleMessageInteraction() async {
    await _handleBackgroundMessageInteraction();
    return _handleForegroundMessageInteraction();
  }

  Future<void> _handleBackgroundMessageInteraction() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  StreamSubscription<RemoteMessage> _handleForegroundMessageInteraction() {
    return FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    _messageHandler?.call(message.data);
  }

}
