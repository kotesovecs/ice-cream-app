// ignore_for_file: use_build_context_synchronously

import 'package:ZmrzlinaApi/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:ice_cream/app/app.locator.dart';
import 'package:ice_cream/app/provider/cart_provider.dart';
import 'package:ice_cream/misc/data_storage_keys.dart';
import 'package:ice_cream/services/data_storage_service.dart';

class CheckoutSheetModel extends BaseViewModel {
  CheckoutSheetModel() {
    loadData();
  }

  final dataStorage = locator<DataStorageService>();

  TextEditingController noteController = TextEditingController();
  DailyMenuDto? _dailyMenuDto;
  bool isLoaded = false;
  bool isAddingNote = false;

  DailyMenuDto? get dailyMenuDto => _dailyMenuDto;

  void toggleNoteField() {
    isAddingNote = !isAddingNote;
    notifyListeners();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

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
    if (_dailyMenuDto != null) {
      isLoaded = true;
      notifyListeners();
    } else {
      // Handle error or empty response
      isLoaded = false;
      notifyListeners();
    }
  }

  num? getVariantIdFromDisplayName(String displayName) {
    final allItems = [...iceCreams, ...slush, ...other];

    for (var item in allItems) {
      for (var size in item.sizes) {
        String itemDisplayName = "${item.name} (${size.size.name})";
        if (itemDisplayName == displayName) {
          return size.id;
        }
      }
    }

    return null; // If no match is found, return null
  }

  Map<String, int> getItemCounts(CartProvider cartProvider) {
    final Map<String, int> itemCounts = {};

    // Early return if _dailyMenuDto is null
    if (_dailyMenuDto == null) return itemCounts;

    for (var entry in cartProvider.orderedVariants.entries) {
      final variantId = entry.key;
      final quantity = entry.value;

      final (itemName, sizeName) = CartProvider.mapVariantToItemSize(variantId, _dailyMenuDto!);

      // Make sure neither name is null
      if (itemName != null && sizeName != null) {
        final displayName = "$itemName ($sizeName)";
        itemCounts[displayName] = quantity;
      }
    }

    return itemCounts;
  }

  String getDisplayName(num variantId) {
    final allItems = [...iceCreams, ...slush, ...other];

    for (var item in allItems) {
      for (var size in item.sizes) {
        if (size.id == variantId) {
          final sizeName = size.size.name;
          return '${item.name} - $sizeName';
        }
      }
    }

    return 'Neznámá položka';
  }

  void addItem(CartProvider cartProvider, String itemName) {
    for (var entry in cartProvider.orderedVariants.entries) {
      final variantId = entry.key;
      final (mappedItemName, sizeName) = CartProvider.mapVariantToItemSize(variantId, _dailyMenuDto!);

      if (mappedItemName == itemName) {
        cartProvider.addNOfVariant(variantId, 1);
        break;
      }
    }
  }

  double getTotalPrice(CartProvider cartProvider) {
    double total = 0.0;

    for (var entry in cartProvider.orderedVariants.entries) {
      final variantId = entry.key;
      final quantity = entry.value;

      final allItems = [...iceCreams, ...slush, ...other];

      for (var item in allItems) {
        for (var variant in item.sizes) {
          if (variant.id == variantId) {
            total += variant.price * quantity;
          }
        }
      }
    }

    return total;
  }

  void submitOrder(BuildContext context) async {
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    String? note = cartProvider.note.isNotEmpty ? cartProvider.note : null;

    String? userName = await dataStorage.getString(DataStorageKey.userName);
    String? userPhoneNumber = await dataStorage.getString(DataStorageKey.userPhoneNumber);
    String? firebaseToken = await dataStorage.getString(DataStorageKey.firebaseToken);

    if (firebaseToken == null) {
      firebaseToken = await FirebaseMessaging.instance.getToken();
      if (firebaseToken != null) {
        await dataStorage.setString(DataStorageKey.firebaseToken, firebaseToken);
      } else {
        return;
      }
    }

    if (userName == null || userName.isEmpty) {
      Fluttertoast.showToast(msg: "Jméno uživatele chybí.");
      closeCheckoutSheet(context);
      return;
    }

    if (userPhoneNumber == null || userPhoneNumber.isEmpty || userPhoneNumber.trim() == "(+420)") {
      Fluttertoast.showToast(msg: "Telefonní číslo uživatele chybí.");
      closeCheckoutSheet(context);
      return;
    }

    if (context.mounted) {
      List<CreateOrderDtoItemsInner> items = [];
      int skippedVariants = 0;

      cartProvider.orderedVariants.forEach((num variantId, int quantity) {
        final (itemName, sizeName) = CartProvider.mapVariantToItemSize(variantId, dailyMenuDto!);

        if (itemName != null && sizeName != null) {
          items.add(CreateOrderDtoItemsInner(itemId: variantId, quantity: quantity));
        } else {
          skippedVariants++;
        }
      });

      if (items.isEmpty) {
        Fluttertoast.showToast(msg: "Prosím vyberte položku dostupnou v denním menu.");
        return;
      }

      if (skippedVariants > 0) {
        Fluttertoast.showToast(msg: "Některé položky nebyly dostupné a nebyly odeslány.");
      }

      CreateOrderDto createOrder = CreateOrderDto(
        name: userName,
        phone: userPhoneNumber,
        firebaseToken: firebaseToken,
        note: note,
        items: items,
      );

      try {
        var response = await CustomerApi().createOrderWithHttpInfo(createOrder);

        if (response.statusCode == 201) {
          Fluttertoast.showToast(
            msg: "Úspěšně odesláno!",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
          );
          cartProvider.clearNote();
          cartProvider.clearCart();

          if (context.mounted) Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(
            msg: "Chyba při vytváření objednávky.",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
          );
          closeCheckoutSheet(context);
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Chyba při připojení k serveru.",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
        );
        closeCheckoutSheet(context);
      }
    }
  }

  void closeCheckoutSheet(BuildContext context) {
    Navigator.of(context).pop();
  }
}
