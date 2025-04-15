import 'dart:async';
import 'package:ZmrzlinaApi/api.dart';
import 'package:stacked/stacked.dart';
import 'package:ice_cream/app/app.locator.dart';
import 'package:ice_cream/misc/data_storage_keys.dart';
import 'package:ice_cream/services/data_storage_service.dart';

class CustomNavBarModel extends IndexTrackingViewModel {
  final Function(int) notifyMainViewModel;

  CustomNavBarModel({required this.notifyMainViewModel}) {
    _startOrderPolling();
  }

  List<OrderDto>? objednavky;
  bool readyOrder = false;
  final dataStorage = locator<DataStorageService>();

  void _startOrderPolling() {
    Timer.periodic(const Duration(milliseconds: 30), (timer) async {
      await updateReadyOrder();
    });
  }

  Future<void> updateReadyOrder() async {
    readyOrder = await hasReadyOrder();
    notifyListeners();
  }

  Future<bool> hasReadyOrder() async {
    String? token = await dataStorage.getString(DataStorageKey.firebaseToken);
    if (token == null) return false;

    try {
      objednavky = await CustomerApi().orderHistoryToken(token);
      return objednavky?.any((order) => order.orderState == OrderDtoOrderStateEnum.vychystane) ?? false;
    } catch (e) {
      //debugPrint('Error fetching orders: $e');
      return false;
    }
  }

  @override
  void setIndex(int value) {
    super.setIndex(value);
    notifyMainViewModel(value);
    notifyListeners();
  }
}
