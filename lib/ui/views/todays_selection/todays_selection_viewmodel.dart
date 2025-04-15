import 'package:ZmrzlinaApi/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:ice_cream/app/app.bottomsheets.dart';
import 'package:ice_cream/app/app.locator.dart';
import 'package:ice_cream/app/provider/cup_provider.dart';
import 'package:ice_cream/misc/data_storage_keys.dart';
import 'package:ice_cream/services/data_storage_service.dart';

class TodaysSelectionViewModel extends BaseViewModel {
  TodaysSelectionViewModel() {
    fetchDailyMenu();
  }

  final _bottomSheetService = locator<BottomSheetService>();
  final dataStorage = locator<DataStorageService>();
  DailyMenuDto? dailyMenu;
  String selectedSize = '';

  Map<String, List<DailyMenuDtoItemsValueItemsInner>> get categoriesMap {
    if (dailyMenu?.items == null) return {};
    return dailyMenu!.items.map((key, value) {
      // Filter out inactive items
      var activeItems = value.items.where((item) => item.active == true).toList();

      return MapEntry(value.name, activeItems);
    });
  }

  void debugActiveItems(List<DailyMenuDtoItemsValueItemsInner> items) {}

  Map<String, List<DailyMenuDtoItemsValueItemsInnerSizesInner>> get categoryPricesMap {
    if (dailyMenu?.items == null) return {};

    return dailyMenu!.items.map(
      (key, value) {
        debugActiveItems(value.items);

        var activeItems = value.items.where((item) => item.active == true).toList();

        return MapEntry(
          value.name,
          activeItems.expand((item) => item.sizes).toList(),
        );
      },
    );
  }

  bool get areAllCategoriesEmpty => categoriesMap.values.every((items) => items.isEmpty);

  bool isCategoryEmpty(List<DailyMenuDtoItemsValueItemsInner> items) => items.isEmpty;

  Future<void> fetchDailyMenu() async {
    setBusy(true);
    try {
      await FirebaseMessaging.instance.getToken();
      dailyMenu = await CustomerApi().getToday();
      debugActiveItems(dailyMenu!.items.values.first.items);
    } catch (e) {
      dailyMenu = null;
    }
    setBusy(false);
    notifyListeners();
  }

  void reloadData() => fetchDailyMenu();

  void openBonusCard() async {
    String? cardNumber = await dataStorage.getString(DataStorageKey.bonusCardNumber);
    cardNumber?.isNotEmpty == true ? showBonusCard(cardNumber!) : showBonusCardSettings();
  }

  void showBonusCard(String number) {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.bonusCard,
      title: "Kartička",
      description: number,
    );
  }

  void showBonusCardSettings() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.bonusCardSettings,
      title: "Nastavení kartičky",
    );
  }

  void navigateToCheckout(BuildContext context) {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.checkout,
      data: Provider.of<CupProvider>(context, listen: false),
      isScrollControlled: true,
    );
  }

  Future<SheetResponse?> showConfirmationBottomSheet({
    required String title,
    required String description,
    required dynamic data,
  }) async {
    return await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.confirm,
      title: title,
      description: description,
      data: data,
    );
  }

  bool isPastOrder() {
    if (dailyMenu?.orderBy == null) return false;

    try {
      List<String> orderByParts = dailyMenu!.orderBy.split(":");

      TimeOfDay orderByTime = TimeOfDay(
        hour: int.parse(orderByParts[0]),
        minute: int.parse(orderByParts[1]),
      );

      TimeOfDay now = TimeOfDay.now();

      return _isTimeAfter(now, orderByTime);
    } catch (e) {
      return false;
    }
  }

  bool _isTimeAfter(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour > t2.hour || (t1.hour == t2.hour && t1.minute > t2.minute);
  }
}
