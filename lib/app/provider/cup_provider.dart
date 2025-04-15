import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/material.dart';

class CupProvider extends ChangeNotifier {
  final List<DailyMenuDtoItemsValueItemsInner> addedItems = [];
  final List<String> sizes = [];
  final List<num> ids = [];
  String _note = "";

  String get note => _note;

  String selectedSize = '';
  num selectedId = 0;

  List<DailyMenuDtoItemsValueItemsInner> get cartItems {
    List<DailyMenuDtoItemsValueItemsInner> cartItemsList = ids.map((id) {
      return addedItems.firstWhere(
        (item) => item.id == id,
        orElse: () {
          return DailyMenuDtoItemsValueItemsInner(id: -1, name: 'Unknown Item', sizes: [], active: false);
        },
      );
    }).toList();
    return cartItemsList;
  }

  void setNote(String newNote) {
    _note = newNote;
    notifyListeners();
  }

  void clearNote() {
    _note = "";
    notifyListeners();
  }

  void addCup(DailyMenuDtoItemsValueItemsInner item) {
    debugPrint(item.toString());
    addedItems.add(item);
    ids.add(item.id);
    notifyListeners();
  }

  void addSize(String selectedSize) {
    this.selectedSize = selectedSize;
    sizes.add(selectedSize);
    notifyListeners();
  }

  void addId(num selectedId) {
    this.selectedId = selectedId;
    ids.add(selectedId);
    notifyListeners();
  }

  void deleteCup(int index) {
    if (index >= 0 && index < addedItems.length) {
      addedItems.removeAt(index);
      notifyListeners();
    }
  }

  void removeOneCup(String itemName) {
    int index = addedItems.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      addedItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearAddedItems() {
    addedItems.clear();
    _note = "";
    notifyListeners();
  }

  Map<num, int> get itemCounts {
    Map<num, int> counts = {};
    for (var item in cartItems) {
      num itemId = item.sizes.isNotEmpty ? item.sizes.first.id : -1;
      counts[itemId] = (counts[itemId] ?? 0) + 1;
    }
    return counts;
  }
}
