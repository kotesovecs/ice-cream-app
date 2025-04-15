import 'package:ZmrzlinaApi/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:ice_cream/app/app.locator.dart';
import 'package:ice_cream/app/provider/cup_provider.dart';
import 'package:ice_cream/misc/data_storage_keys.dart';
import 'package:ice_cream/services/data_storage_service.dart';
import 'package:ice_cream/ui/views/main/main_viewmodel.dart';

class CheckoutViewModel extends BaseViewModel {
  CheckoutViewModel() {
    loadData();
  }

  TextEditingController myController = TextEditingController();
  DailyMenuDto? _dailyMenuDto;
  bool isLoaded = false;
  final dataStorage = locator<DataStorageService>();

  DailyMenuDto? get dailyMenuDto => _dailyMenuDto;

  List<DailyMenuDtoItemsValueItemsInner> get iceCreams {
    if (_dailyMenuDto?.items == null) return [];
    return _dailyMenuDto!.items.values
        .where((category) => category.name == 'Točené zmrzliny')
        .expand((category) => category.items.cast<DailyMenuDtoItemsValueItemsInner>())
        .toList();
  }

  List<DailyMenuDtoItemsValueItemsInner> get slush {
    if (_dailyMenuDto?.items == null) return [];
    return _dailyMenuDto!.items.values
        .where((category) => category.name == 'Tříště')
        .expand((category) => category.items.cast<DailyMenuDtoItemsValueItemsInner>())
        .toList();
  }

  List<DailyMenuDtoItemsValueItemsInner> get other {
    if (_dailyMenuDto?.items == null) return [];
    return _dailyMenuDto!.items.values
        .where((category) => category.name == 'Ostatní')
        .expand((category) => category.items.cast<DailyMenuDtoItemsValueItemsInner>())
        .toList();
  }

  Future loadData() async {
    _dailyMenuDto = await CustomerApi().getToday();
    isLoaded = true;
    notifyListeners();
  }

  Map<String, int> getItemCounts(CupProvider cupProvider) {
    final Map<String, int> itemCounts = {};
    for (var item in cupProvider.addedItems) {
      itemCounts[item.name] = (itemCounts[item.name] ?? 0) + 1;
    }
    return itemCounts;
  }

  String getDisplayName(String itemName) {
    List<DailyMenuDtoItemsValueItemsInner> allItems = [
      ...iceCreams,
      ...slush,
      ...other,
    ];

    var matchingItem = allItems.firstWhere(
      (item) => item.name == itemName,
      orElse: () => DailyMenuDtoItemsValueItemsInner(name: "Neznámá položka", active: true, id: 0),
    );

    return matchingItem.name;
  }

  void addItem(CupProvider cupProvider, String itemName) {
    var item = cupProvider.addedItems.firstWhere((item) => item.name == itemName,
        orElse: () => DailyMenuDtoItemsValueItemsInner(name: "", active: true, id: 0));
    if (item.name.isNotEmpty) {
      cupProvider.addCup(item);
    }
  }

  void submitOrder(BuildContext context) async {
    final note = myController.text.isNotEmpty ? myController.text : null;
    String? userName = await dataStorage.getString(DataStorageKey.userName);
    String? userPhoneNumber = await dataStorage.getString(DataStorageKey.userPhoneNumber);

    String? firebaseToken = await FirebaseMessaging.instance.getToken();

    if (firebaseToken == null) {
      debugPrint("Chyba: Nelze získat Firebase Token.");
      return;
    }

    if (userName == null || userName.isEmpty) {
      Fluttertoast.showToast(msg: "Jméno uživatele chybí.");
      return;
    }

    if (userPhoneNumber == null || userPhoneNumber.isEmpty || userPhoneNumber.trim() == "(+420)") {
      Fluttertoast.showToast(msg: "Telefonní číslo uživatele chybí.");
      return;
    }

    if (context.mounted) {
      CupProvider cupProvider = Provider.of<CupProvider>(context, listen: false);
      List<CreateOrderDtoItemsInner> items = [];

      Map<num, int> itemCounts = {};
      for (DailyMenuDtoItemsValueItemsInner element in cupProvider.addedItems) {
        num itemId = element.sizes.first.id;
        itemCounts[itemId] = (itemCounts[itemId] ?? 0) + 1;
      }

      itemCounts.forEach((num itemId, int quantity) {
        items.add(CreateOrderDtoItemsInner(itemId: itemId, quantity: quantity));
      });

      if (items.isEmpty) {
        Fluttertoast.showToast(msg: "Prosím vyberte položku.");
        return;
      }

      CreateOrderDto createOrder = CreateOrderDto(
        name: userName,
        phone: userPhoneNumber,
        firebaseToken: firebaseToken,
        note: note,
        items: items,
      );

      await CustomerApi().createOrderWithHttpInfo(createOrder);
      Fluttertoast.showToast(msg: "Úspěšně odesláno!", gravity: ToastGravity.CENTER, backgroundColor: Colors.grey);
      cupProvider.clearAddedItems();
      if (context.mounted) navigateToTodaysSelection(context);
    }
  }

  void navigateToTodaysSelection(BuildContext context) {
    context.read<MainViewModel>().jumpToPage(1);
    notifyListeners();
    //TODO fix navigation here
  }
}
