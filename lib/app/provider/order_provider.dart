import 'dart:convert';

import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderDto>? objednavky = [];
  bool hasReadyOrder = false;

  // No longer using dataStorage locator, using SharedPreferences directly
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  OrderProvider() {
    loadOrdersFromLocalStorage();
  }

  // Load orders from SharedPreferences
  Future<void> loadOrdersFromLocalStorage() async {
    try {
      final prefs = await _prefs;
      final jsonString = prefs.getString('local_orders'); // Use the key 'local_orders'
      if (jsonString != null) {
        final List decoded = json.decode(jsonString);
        objednavky = decoded.map((item) => OrderDto.fromJson(item)).toList().cast<OrderDto>();

        bool newState = objednavky?.any(
              (order) => order.orderState == OrderDtoOrderStateEnum.vychystane,
            ) ??
            false;

        if (newState != hasReadyOrder) {
          hasReadyOrder = newState;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading orders from local storage: $e');
    }
  }

  // Save orders to SharedPreferences
  Future<void> saveOrdersToLocalStorage(List<OrderDto> orders) async {
    try {
      final prefs = await _prefs;
      final encoded = json.encode(orders.map((order) => order.toJson()).toList());
      await prefs.setString('local_orders', encoded); // Save using the key 'local_orders'
      objednavky = orders;

      bool newState = orders.any(
        (order) => order.orderState == OrderDtoOrderStateEnum.vychystane,
      );

      if (newState != hasReadyOrder) {
        hasReadyOrder = newState;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error saving orders to local storage: $e');
    }
  }

  // Save a bonus card number to SharedPreferences (directly replacing DataStorageService)
  Future<void> saveBonusCardNumber(String number) async {
    final prefs = await _prefs;
    await prefs.setString('bonus_card_number', number); // Save with key 'bonus_card_number'
  }
}
