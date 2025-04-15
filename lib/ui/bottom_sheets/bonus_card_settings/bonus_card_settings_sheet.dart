import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'bonus_card_settings_sheet_model.dart';
import 'package:ice_cream/ui/common/ui_helpers.dart';

class BonusCardSettingsSheet extends StackedView<BonusCardSettingsSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const BonusCardSettingsSheet({
    required this.request,
    required this.completer,
    super.key,
  });

  @override
  Widget builder(
    BuildContext context,
    BonusCardSettingsSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            request.title ?? 'Zákaznická kartička',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          verticalSpaceSmall,
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: TextField(
              controller: viewModel.bonusController,
              decoration: const InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                labelText: 'Zadejte číslo vaší karty',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          TextButton(
            onPressed: viewModel.toggleScanner,
            child: Text(
              "Naskenovat kamerou telefonu",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          if (viewModel.isScannerActive) // Show scanner only when active
            Expanded(
              child: Column(
                children: [
                  verticalSpaceSmall,
                  SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: MobileScanner(
                        onDetect: viewModel.onBarcodeScanned,
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                ],
              ),
            ),
          verticalSpaceSmall,
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: MaterialButton(
              height: 50,
              onPressed: () {
                viewModel.setCard(viewModel.bonusController.text).then((response) {
                  completer?.call(SheetResponse(confirmed: response));
                });
              },
              child: const Text(
                "Přidat kartičku",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          verticalSpaceMedium
        ],
      ),
    );
  }

  @override
  BonusCardSettingsSheetModel viewModelBuilder(BuildContext context) => BonusCardSettingsSheetModel();
}
