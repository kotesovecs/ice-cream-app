import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:provider/provider.dart';
import 'package:ice_cream/app/app.bottomsheets.dart';
import 'package:ice_cream/app/provider/cart_provider.dart';
import 'package:ice_cream/app/provider/cup_provider.dart';
import 'package:ice_cream/app/app.locator.dart';

class CustomAppbarModel extends IndexTrackingViewModel {
  final Function(int) notifyMainViewModel;
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  CustomAppbarModel({required this.notifyMainViewModel});

  int getItemCount(BuildContext context) {
    return Provider.of<CartProvider>(context, listen: true).orderedVariantList.length;
  }

  void openCheckoutSheet(BuildContext context) {
    final itemCount = Provider.of<CartProvider>(context, listen: false).orderedVariantList.length;

    if (itemCount == 0) {
      return;
    }

    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.checkout,
      data: Provider.of<CupProvider>(context, listen: false),
      isScrollControlled: true,
    );
  }

  Widget buildAppBarIcon({
    required BuildContext context,
    required int index,
    IconData? icon,
    required bool isSvg,
    String? badgeText,
    required Function(int) setIndex,
  }) {
    final isSelected = currentIndex == index;
    return isSvg
        ? GestureDetector(
            onTap: () => setIndex(index),
            child: Image.asset(
              'assets/images/logo_dzk.png',
              scale: 4.5,
            )
            // SvgPicture.asset(
            //   'assets/images/logo.svg',
            //   fit: BoxFit.contain,
            //   height: 95,
            //   alignment: Alignment.centerLeft,
            // ),
            )
        : IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 35,
                  color: isSelected ? Colors.white.withValues(alpha: 0.9) : Colors.white,
                ),
                if (badgeText != null)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      child: Text(
                        badgeText,
                        style: const TextStyle(fontSize: 11, color: Colors.black),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              if (index == 3) {
                openCheckoutSheet(context);
              } else {
                setIndex(index);
              }
            },
          );
  }

  @override
  void setIndex(int value) {
    super.setIndex(value);
    notifyMainViewModel(value);
    notifyListeners();
  }
}
