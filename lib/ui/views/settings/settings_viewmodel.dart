import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:ice_cream/app/app.bottomsheets.dart';
import 'package:ice_cream/app/app.locator.dart';
import 'package:ice_cream/misc/data_storage_keys.dart';
import 'package:ice_cream/services/data_storage_service.dart';

class SettingsViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final dataStorage = locator<DataStorageService>();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneNumberController = TextEditingController();

  String? _firebaseToken;

  SettingsViewModel() {
    loadUserData();
  }

  @override
  void dispose() {
    userNameController.dispose();
    userPhoneNumberController.dispose();
    super.dispose();
  }

  bool isCardNumberEmpty = false;

  void updateBonusCard(String cardNumber) async {
    String? storedCardNumber = await dataStorage.getString(DataStorageKey.bonusCardNumber);

    isCardNumberEmpty = storedCardNumber == null || storedCardNumber.isEmpty;

    notifyListeners();
  }

  void showBonusCardSettings() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.bonusCardSettings,
      title: 'Zákaznická kartička',
      description: '',
    );
  }

  Future<void> saveUserData() async {
    String name = userNameController.text.trim();
    String phone = userPhoneNumberController.text.trim();

    await dataStorage.setString(DataStorageKey.userName, name.isNotEmpty ? name : "");
    await dataStorage.setString(DataStorageKey.userPhoneNumber, phone.length >= 7 ? phone : "(+420)");

    if (phone.length < 7) {
      userPhoneNumberController.text = "(+420)";
    }

    _firebaseToken = await dataStorage.getString(DataStorageKey.firebaseToken);
    if (_firebaseToken == null) {
      _firebaseToken = await FirebaseMessaging.instance.getToken();
      if (_firebaseToken != null) {
        await dataStorage.setString(DataStorageKey.firebaseToken, _firebaseToken!);
        debugPrint("Firebase Token Saved: $_firebaseToken");
      }
    }

    Fluttertoast.showToast(msg: "Uloženo.", gravity: ToastGravity.CENTER, backgroundColor: Colors.grey);
  }

  Future<void> loadUserData() async {
    userNameController.text = await dataStorage.getString(DataStorageKey.userName) ?? "";
    userPhoneNumberController.text = await dataStorage.getString(DataStorageKey.userPhoneNumber) ?? "(+420)";
    _firebaseToken = await dataStorage.getString(DataStorageKey.firebaseToken); // Load stored token

    notifyListeners();
  }
}
