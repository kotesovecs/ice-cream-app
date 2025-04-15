import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:ice_cream/app/app.dialogs.dart';
import 'package:ice_cream/app/app.locator.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final DialogService _dialogService = locator<DialogService>();

  static Future<void> initialize(BuildContext context) async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          //print("APNs Token: $apnsToken");
        }
        debugPrint("Push notification permission granted");
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint("Push notification permission denied by the user.");
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (context.mounted) {
          _showForegroundNotification(context, message);
        }
      });

      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        //print("FCM Token: $token");
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        //print("Token refreshed: $newToken");
      });
    } catch (e) {
      debugPrint("Error initializing push notifications: $e");
    }
  }

  static void _showForegroundNotification(BuildContext context, RemoteMessage message) {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: message.notification?.title ?? "New Notification",
      description: message.notification?.body ?? "No message body",
    );
  }
}
