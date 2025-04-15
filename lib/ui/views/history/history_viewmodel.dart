import 'package:ZmrzlinaApi/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HistoryViewModel extends FutureViewModel {
  bool _isLoaded = false;
  bool _isLoading = false;

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  List<OrderDto>? objednavky;

  HistoryViewModel() {
    _initializeFirebaseListener();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? firebaseToken = await FirebaseMessaging.instance.getToken();

      if (firebaseToken == null) {
        debugPrint("Error: Firebase token is null!");
        return;
      }
      objednavky = await CustomerApi().orderHistoryToken(firebaseToken);
    } catch (e) {
      debugPrint("Error fetching history: $e");
    }

    _isLoading = false;
    _isLoaded = true;
    notifyListeners();
  }

  void _initializeFirebaseListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Push notification received: ${message.notification?.title}");
      loadData();
      notifyListeners();
    });
  }

  @override
  Future futureToRun() => loadData();
}
