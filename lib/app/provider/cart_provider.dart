import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final Map<num, int> orderedVariants = {};
  List<MapEntry<num, int>> get orderedVariantList => orderedVariants.entries.toList();

  String _note = "";

  String get note => _note;

  void setNote(String newNote) {
    _note = newNote;
    notifyListeners();
  }

  void clearNote() {
    _note = "";
    notifyListeners();
  }

  void clearCart() {
    orderedVariants.clear();
    notifyListeners();
  }

  void addVariant(num variantId, int quantity) {
    orderedVariants[variantId] = quantity;
    debugPrint('🛒 addVariant: Set variant $variantId quantity to $quantity');
    debugPrint('📦 Current cart: $orderedVariants');
    notifyListeners();
  }

  void removeAllOfVariant(num variantId) {
    orderedVariants.remove(variantId);
    debugPrint('❌ removeAllOfVariant: Removed variant $variantId');
    debugPrint('📦 Current cart: $orderedVariants');
    notifyListeners();
  }

  void removeNOfVariant(num variantId, int quantity) {
    if (orderedVariants.containsKey(variantId)) {
      orderedVariants[variantId] = orderedVariants[variantId]! - quantity;
      debugPrint('➖ removeNOfVariant: Removed $quantity of variant $variantId');
      if (orderedVariants[variantId]! <= 0) {
        orderedVariants.remove(variantId);
        debugPrint('🚫 Variant $variantId quantity dropped to 0 or less, removing from cart');
      }
    } else {
      debugPrint('⚠️ removeNOfVariant: Variant $variantId not found in cart');
    }
    debugPrint('📦 Current cart: $orderedVariants');
    notifyListeners();
  }

  void addNOfVariant(num variantId, int quantity) {
    if (!variantIsInCart(variantId)) {
      debugPrint('🆕 addNOfVariant: Variant $variantId not in cart, adding with quantity $quantity');
      addVariant(variantId, quantity);
      return;
    }

    orderedVariants[variantId] = orderedVariants[variantId]! + quantity;
    debugPrint('➕ addNOfVariant: Added $quantity to variant $variantId');
    debugPrint('📦 Current cart: $orderedVariants');
    notifyListeners();
  }

  bool variantIsInCart(num variantId) {
    bool exists = orderedVariants.containsKey(variantId);
    debugPrint('🔍 variantIsInCart: Variant $variantId is ${exists ? "" : "not "}in cart');
    return exists;
  }

  static (String?, String?) mapVariantToItemSize(num variantId, DailyMenuDto dailyMenu) {
    debugPrint('🔄 mapVariantToItemSize: Looking up variant $variantId');
    for (var category in dailyMenu.items.entries) {
      for (var item in category.value.items) {
        for (var variant in item.sizes) {
          if (variant.id == variantId) {
            debugPrint('✅ Found variant $variantId → Item: ${item.name}, Size: ${variant.size.name}');
            return (item.name, variant.size.name);
          }
        }
      }
    }
    debugPrint('❓ Variant $variantId not found in menu');
    return (null, null);
  }

  Map<num, int> checkout() {
    debugPrint('🧾 checkout: Current cart = $orderedVariants');
    return orderedVariants;
  }
}
