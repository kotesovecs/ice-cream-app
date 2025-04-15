import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'action_button_model.dart';

class ActionButton extends StackedView<ActionButtonModel> {
  const ActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool active;
  final GestureTapCallback onTap;

  @override
  Widget builder(
    BuildContext context,
    ActionButtonModel viewModel,
    Widget? child,
  ) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: active ? Colors.white : Colors.grey.shade300,
          boxShadow: [
            BoxShadow(
              color: active ? Colors.black.withValues(alpha: 0.1) : Colors.transparent,
              spreadRadius: 1,
              blurRadius: 14,
              offset: const Offset(0, 1.1),
            ),
          ],
        ),
        child: MaterialButton(
          height: 50,
          onPressed: () => onTap(),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              icon,
              size: 24,
              color: active ? Theme.of(context).primaryColor : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Text(title,
                style: TextStyle(color: active ? Theme.of(context).primaryColor : Colors.grey.shade500, fontSize: 16))
          ]),
        ),
      ),
    );
  }

  @override
  ActionButtonModel viewModelBuilder(
    BuildContext context,
  ) =>
      ActionButtonModel();
}
