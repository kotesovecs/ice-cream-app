import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'custom_appbar_model.dart';

class CustomAppbar extends StackedView<CustomAppbarModel> {
  const CustomAppbar({this.selectedIndex = 0, required this.onIndexChanged, super.key});

  final int selectedIndex;
  final Function(int) onIndexChanged;

  @override
  Widget builder(BuildContext context, CustomAppbarModel viewModel, Widget? child) {
    final itemCount = viewModel.getItemCount(context);

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 21, right: 21, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  viewModel.buildAppBarIcon(
                      context: context,
                      index: 2,
                      icon: Icons.settings_outlined,
                      isSvg: false,
                      badgeText: null,
                      setIndex: (index) => viewModel.setIndex(index)),
                  viewModel.buildAppBarIcon(
                    context: context,
                    index: 3,
                    icon: Icons.shopping_cart_outlined,
                    isSvg: false,
                    badgeText: itemCount > 0 ? itemCount.toString() : null,
                    setIndex: (index) => viewModel.setIndex(index),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      shape: CustomShapeBorder(),
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  @override
  CustomAppbarModel viewModelBuilder(BuildContext context) => CustomAppbarModel(notifyMainViewModel: onIndexChanged);
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const double decoOffset = 34.0;
    const int circleCount = 8;
    final double circleRadius = rect.width / circleCount;
    Path bg = Path();
    Path deco = Path();

    bg.lineTo(0, rect.height - circleRadius / 2 + decoOffset);
    bg.lineTo(rect.width, rect.height - circleRadius / 2 + decoOffset);
    bg.lineTo(rect.width, 0.0);
    bg.close();

    for (int i = 0; i < circleCount; i++) {
      deco.addOval(
        Rect.fromLTWH(i * circleRadius, rect.height - circleRadius + decoOffset, circleRadius, circleRadius),
      );
    }

    return Path.combine(PathOperation.union, bg, deco);
  }
}
