import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../data_models/firebase_notification_model.dart';

class NotificationsBloc {
  NotificationsBloc._internal();

  static final NotificationsBloc instance = NotificationsBloc._internal();

  final BehaviorSubject<FirebaseNotificationModel> _notificationsStreamController =
      BehaviorSubject<FirebaseNotificationModel>();

  Stream<FirebaseNotificationModel> get notificationsStream => _notificationsStreamController.stream;

  void newNotification(FirebaseNotificationModel notification) {
    _notificationsStreamController.sink.add(notification);
  }

  void dispose() {
    _notificationsStreamController.close();
  }
}

class NotificationHandler {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final Random _random = Random.secure();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      var notification = FirebaseNotificationModel.fromJson(msg.data);
      _navigateToScreen(notification);
      _incomingNotification(notification);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      var notification = FirebaseNotificationModel.fromJson(msg.data);
      _incomingNotification(notification);
      _showNotification(notification);
    });

    if (Platform.isIOS) await _requestIOSPermissions();

    await _subscribeToNotifications();
  }

  Future<void> _subscribeToNotifications() async {
    await _fcm.subscribeToTopic("all");
  }

  // Future<void> _unsubscribeFromNotifications() async {
  //   await _fcm.unsubscribeFromTopic("all");
  // }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  Future<void> _requestIOSPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');
    } else {
      //print('User declined or has not accepted permission');
    }
  }

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> _showNotification(FirebaseNotificationModel notification) async {
    try {
      var androidSettings = const AndroidNotificationDetails(
        'main_channel',
        'Main Channel',
        importance: Importance.high,
        priority: Priority.high,
      );

      var iosSettings = const DarwinNotificationDetails();

      var platformSettings = NotificationDetails(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.show(
        _random.nextInt(1000000),
        notification.title,
        notification.body,
        platformSettings,
        payload: notification.ticketId?.toString(),
      );
    } catch (e) {
      //print('Error showing notification: $e');
    }
  }

  void _incomingNotification(FirebaseNotificationModel notification) {
    NotificationsBloc.instance.newNotification(notification);
  }

  void _navigateToScreen(FirebaseNotificationModel notification) {
    _navigationService.navigateTo('/home'); // Adjust this route as needed
  }
}
