import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'circular_button_model.dart';

class CircularButton extends StackedView<CircularButtonModel> {
  const CircularButton({
    super.key,
    this.title = "",
    required this.accept,
    required this.onTap,
    this.inactive = false,
    required this.sizes,
  });

  final String title;
  final bool accept;
  final bool inactive;
  final GestureTapCallback onTap;
  final List<DailyMenuDtoItemsValueItemsInnerSizesInner> sizes;

  @override
  Widget builder(
    BuildContext context,
    CircularButtonModel viewModel,
    Widget? child,
  ) {
    return Opacity(
      opacity: inactive ? 0.5 : 1.0,
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: accept ? Colors.black.withValues(alpha: 0.1) : Colors.transparent,
              spreadRadius: 1,
              blurRadius: 14,
              offset: const Offset(0, 1.1),
            ),
          ],
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: inactive ? Colors.grey.shade400 : (accept ? Theme.of(context).primaryColor : Colors.grey.shade400),
            ),
          ),
          child: MaterialButton(
            onPressed: onTap,
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: inactive ? Colors.grey : Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  CircularButtonModel viewModelBuilder(BuildContext context) => CircularButtonModel();
}
