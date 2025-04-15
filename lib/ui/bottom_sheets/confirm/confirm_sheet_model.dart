import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:ice_cream/app/app.bottomsheets.dart';
import 'package:ice_cream/app/provider/cart_provider.dart';
import 'package:ice_cream/app/provider/cup_provider.dart';
import 'package:ice_cream/app/app.locator.dart';

class ConfirmSheetModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  String? selectedSize;
  num? selectedId;
  DailyMenuDtoItemsValueItemsInnerSizesInner? selectedSizeObject;

  void setSize(String size, num id, DailyMenuDtoItemsValueItemsInnerSizesInner fullSize) {
    selectedSize = size;
    selectedId = id;
    selectedSizeObject = fullSize;
    notifyListeners();
  }

  String get selectedPriceText => selectedSizeObject != null ? '${selectedSizeObject!.price} Kč' : '';

  void navigateToCheckout(BuildContext context) {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.checkout,
      data: Provider.of<CupProvider>(context, listen: false),
      isScrollControlled: true,
    );
  }

  void onAddPressed({
    required BuildContext context,
    required Function(SheetResponse response)? completer,
  }) {
    if (selectedSize == null || selectedSize!.isEmpty) {
      Fluttertoast.showToast(
          msg: "Prosím vyberte velikost", gravity: ToastGravity.CENTER, backgroundColor: Colors.grey);
      return;
    }

    completer?.call(SheetResponse(confirmed: true));
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addNOfVariant(selectedId!, 1);
    navigateToCheckout(context);
  }
}
