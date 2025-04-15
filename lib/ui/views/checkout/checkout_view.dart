import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:ice_cream/app/provider/cup_provider.dart';
import 'checkout_viewmodel.dart';

class CheckoutView extends StackedView<CheckoutViewModel> {
  const CheckoutView({super.key});

  @override
  Widget builder(BuildContext context, CheckoutViewModel viewModel, Widget? child) {
    final cupProvider = Provider.of<CupProvider>(context);
    final textColor = Theme.of(context).primaryColor;
    final boxDecoration = _buildBoxDecoration();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Column(
          children: [
            const Gap(50),
            const Text(
              "Výběr zmrzliny",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Gap(20),
            _buildItemList(viewModel, cupProvider, textColor, boxDecoration),
            TextButton(
              onPressed: () => viewModel.navigateToTodaysSelection(context),
              child: Text("+ Vybrat další", style: TextStyle(color: textColor)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, viewModel),
    );
  }

  Widget _buildItemList(
    CheckoutViewModel viewModel,
    CupProvider cupProvider,
    Color textColor,
    BoxDecoration boxDecoration,
  ) {
    final itemCounts = viewModel.getItemCounts(cupProvider);

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCounts.length,
        itemBuilder: (context, index) {
          final itemName = itemCounts.keys.elementAt(index);
          final itemCount = itemCounts[itemName]!;
          return _buildItemRow(viewModel, cupProvider, itemName, itemCount, textColor, boxDecoration);
        },
      ),
    );
  }

  Widget _buildItemRow(
    CheckoutViewModel viewModel,
    CupProvider cupProvider,
    String itemName,
    int itemCount,
    Color textColor,
    BoxDecoration boxDecoration,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildCupItem(viewModel, itemName, boxDecoration)),
          // _buildActionButton("-", textColor, () => cupProvider.removeOneCup(itemName), boxDecoration),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemCount.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _buildActionButton("+", textColor, () => viewModel.addItem(cupProvider, itemName), boxDecoration),
        ],
      ),
    );
  }

  Widget _buildCupItem(CheckoutViewModel viewModel, String itemName, BoxDecoration boxDecoration) {
    String displayName = viewModel.getDisplayName(itemName);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: boxDecoration,
      height: 50,
      alignment: Alignment.center,
      child: Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed, BoxDecoration boxDecoration) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 50,
      width: 35,
      decoration: boxDecoration,
      child: TextButton(
        onPressed: onPressed,
        child: Center(child: Text(label, style: TextStyle(color: color, fontSize: 18))),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CheckoutViewModel viewModel) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      child: SizedBox(
        height: 60,
        child: TextButton(
          onPressed: () => viewModel.submitOrder(context),
          child: const Text("Objednat", style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(4.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.4),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1.1),
        ),
      ],
    );
  }

  @override
  CheckoutViewModel viewModelBuilder(BuildContext context) => CheckoutViewModel();
}
