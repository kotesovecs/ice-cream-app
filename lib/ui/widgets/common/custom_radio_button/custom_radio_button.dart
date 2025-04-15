import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_radio_button_model.dart';

class CustomRadioButton extends StackedView<CustomRadioButtonModel> {
  const CustomRadioButton({super.key});

  @override
  Widget builder(
    BuildContext context,
    CustomRadioButtonModel viewModel,
    Widget? child,
  ) {
    return Expanded(
        child: Container(
            height: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: (viewModel.value == viewModel.index) ? const Color(0Xfff2e5dc) : Colors.grey.shade200,
                border: Border.all(
                    color:
                        (viewModel.value == viewModel.index) ? Theme.of(context).primaryColor : Colors.grey.shade200)),
            child: MaterialButton(
              height: 50,
              onPressed: () {
                viewModel.value = viewModel.index;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      viewModel.value == viewModel.index
                          ? 'assets/images/kelimek_${viewModel.size}_primary.svg'
                          : 'assets/images/kelimek_${viewModel.size}.svg',
                      height: 18),
                  const SizedBox(width: 8),
                  Text('${viewModel.size == 'm' ? viewModel.sizeM : viewModel.sizeL} g',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (viewModel.value == viewModel.index)
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade800,
                          fontSize: 16)),
                ],
              ),
            )));
  }

  @override
  CustomRadioButtonModel viewModelBuilder(
    BuildContext context,
  ) =>
      CustomRadioButtonModel();
}
