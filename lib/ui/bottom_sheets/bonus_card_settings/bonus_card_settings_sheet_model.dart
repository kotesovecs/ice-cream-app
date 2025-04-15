import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BonusCardSettingsSheetModel extends BaseViewModel {
  TextEditingController bonusController = TextEditingController();
  bool isScannerActive = false;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  BonusCardSettingsSheetModel() {
    loadCardNumber();
  }

  Future<void> loadCardNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedNumber = prefs.getString('bonus_card_number');

    if (storedNumber!.isNotEmpty) {
      bonusController.text = storedNumber;
      notifyListeners();
    }
  }

  void toggleScanner() {
    isScannerActive = !isScannerActive;
    notifyListeners();
  }

  void onBarcodeScanned(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    if (barcode.rawValue != null) {
      bonusController.text = barcode.rawValue!;
      isScannerActive = false;
      notifyListeners();
    }
  }

  Future<bool> setCard(String number) async {
    final prefs = await SharedPreferences.getInstance();
    if (number.length == 13) {
      await prefs.setString('bonus_card_number', number);
      Fluttertoast.showToast(msg: "Karta přidána", gravity: ToastGravity.CENTER, backgroundColor: Colors.grey);
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Špatné nebo chybějící číslo", gravity: ToastGravity.CENTER, backgroundColor: Colors.grey);
      await prefs.setString('bonus_card_number', '');
      return false;
    }
  }
}
