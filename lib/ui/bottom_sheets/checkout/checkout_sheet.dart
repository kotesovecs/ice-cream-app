import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'checkout_sheet_model.dart';
import 'package:provider/provider.dart';
import 'package:ice_cream/app/provider/cart_provider.dart';

class CheckoutSheet extends StackedView<CheckoutSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const CheckoutSheet({required this.request, required this.completer, super.key});

  @override
  Widget builder(BuildContext context, CheckoutSheetModel viewModel, Widget? child) {
    final cartProvider = Provider.of<CartProvider>(context);

    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHandle(),
                  const Gap(10),
                  _buildHeader(context),
                  const Gap(10),
                  _buildItemList(viewModel, cartProvider, context),
                  TextButton(
                    onPressed: () => viewModel.closeCheckoutSheet(context),
                    child: Text("+ Vybrat další", style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  _buildTotalPrice(viewModel, cartProvider),
                  _buildNoteSection(viewModel, cartProvider, context),
                  const Gap(10),
                  _buildSubmitButton(context, viewModel),
                  const Gap(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandle() => Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          width: 60,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.black12,
          ),
        ),
      );

  Widget _buildHeader(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Vaše objednávka',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
              fontSize: 22,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 32, color: Colors.grey.shade800),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

  Widget _buildItemList(CheckoutSheetModel viewModel, CartProvider cartProvider, BuildContext context) {
    final itemCounts = viewModel.getItemCounts(cartProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: itemCounts.isEmpty ? Colors.transparent : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: itemCounts.isEmpty
          ? const SizedBox.shrink()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: itemCounts.entries.map((entry) {
                return _buildItemRow(viewModel, cartProvider, entry.key, entry.value, context);
              }).toList(),
            ),
    );
  }

  Widget _buildItemRow(
    CheckoutSheetModel viewModel,
    CartProvider cartProvider,
    String displayName,
    int itemCount,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Gap(10),
          Text(displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Container()),
          Row(
            children: [
              _buildRoundButton(
                Icons.remove,
                () {
                  final variantId = viewModel.getVariantIdFromDisplayName(displayName);
                  if (variantId != null) {
                    cartProvider.removeNOfVariant(variantId, 1);
                  }
                },
                context,
              ),
              Text(itemCount.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildRoundButton(
                Icons.add,
                () {
                  final variantId = viewModel.getVariantIdFromDisplayName(displayName);
                  if (variantId != null) {
                    cartProvider.addNOfVariant(variantId, 1);
                  }
                },
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onPressed, BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: 12),
            ),
          ),
        ),
      );

  Widget _buildTotalPrice(CheckoutSheetModel viewModel, CartProvider cartProvider) {
    double totalPrice = viewModel.getTotalPrice(cartProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Celkem: ${totalPrice.toStringAsFixed(0)} Kč"),
        ],
      ),
    );
  }

  Widget _buildNoteSection(CheckoutSheetModel viewModel, CartProvider cartProvider, BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: viewModel.isAddingNote || cartProvider.note.isNotEmpty
          ? ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: SingleChildScrollView(
                child: TextField(
                  controller: TextEditingController(text: cartProvider.note)
                    ..selection = TextSelection.collapsed(offset: cartProvider.note.length),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: cartProvider.setNote,
                  decoration: InputDecoration(
                    labelText: "Poznámka",
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(12),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          cartProvider.clearNote();
                          viewModel.toggleNoteField();
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: const Center(
                            child: Icon(Icons.clear, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : TextButton(
              onPressed: viewModel.toggleNoteField,
              child: Text("+ Přidat poznámku", style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, CheckoutSheetModel viewModel) => Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => viewModel.submitOrder(context),
            child: const Text('Objednat', style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
      );

  @override
  CheckoutSheetModel viewModelBuilder(BuildContext context) => CheckoutSheetModel();
}
