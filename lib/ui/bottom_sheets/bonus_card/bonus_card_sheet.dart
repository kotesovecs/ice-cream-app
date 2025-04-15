import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'bonus_card_sheet_model.dart';

class BonusCardSheet extends StackedView<BonusCardSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const BonusCardSheet({required this.request, required this.completer, super.key});

  @override
  Widget builder(BuildContext context, BonusCardSheetModel viewModel, Widget? child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHandle(),
              const SizedBox(height: 2),
              _buildHeader(context),
              const SizedBox(height: 36),
              _buildCard(context, viewModel.cardNumber),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 60,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.black12,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Vaše bonusová karta',
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
  }

  Widget _buildCard(BuildContext context, String? cardNumber) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.0),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1.1),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            _buildCardHeader(),
            _buildBarcode(cardNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'assets/images/logo_dzk.png',
                scale: 4,
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcode(String? cardNumber) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      child: BarcodeWidget(
        barcode: Barcode.ean13(),
        data: cardNumber ?? '',
        errorBuilder: (context, error) => Center(child: Text(error)),
      ),
    );
  }

  @override
  BonusCardSheetModel viewModelBuilder(BuildContext context) => BonusCardSheetModel();
}
