import 'package:stacked/stacked.dart';
import 'package:ice_cream/app/app.locator.dart';
import 'package:ice_cream/misc/data_storage_keys.dart';
import 'package:ice_cream/services/data_storage_service.dart';

class BonusCardSheetModel extends BaseViewModel {
  BonusCardSheetModel() {
    loadCardNumber();
  }
  final dataStorage = locator<DataStorageService>();

  String? cardNumber;

  Future<void> loadCardNumber() async {
    String? storedCardNumber = await dataStorage.getString(DataStorageKey.bonusCardNumber);

    if (storedCardNumber != null && storedCardNumber.length >= 12) {
      cardNumber = fixEAN13(storedCardNumber.substring(0, 12));
    } else {
      cardNumber = ''; // Handle invalid or missing card numbers
    }

    notifyListeners();
  }

  String fixEAN13(String data) {
    if (data.length != 12) {
      throw ArgumentError("EAN-13 requires 12 digits before checksum calculation.");
    }

    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(data[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    int checksum = (10 - (sum % 10)) % 10;

    return data + checksum.toString();
  }
}
