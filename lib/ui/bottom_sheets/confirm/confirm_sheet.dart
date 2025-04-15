import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'confirm_sheet_model.dart';

class ConfirmSheet extends StackedView<ConfirmSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const ConfirmSheet({required this.request, required this.completer, super.key});

  @override
  Widget builder(
    BuildContext context,
    ConfirmSheetModel viewModel,
    Widget? child,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHandle(),
              const SizedBox(height: 2),
              _buildHeader(context, viewModel),
              const SizedBox(height: 18),
              _buildSizeToggle(context, viewModel),
              //_buildIdToggle(context, viewModel),
              _buildButton(context, viewModel),
              const SizedBox(height: 36),
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

  Widget _buildHeader(BuildContext context, ConfirmSheetModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            request.title ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
              fontSize: 18,
            ),
          ),
          Text(
            viewModel.selectedPriceText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 32, color: Colors.grey.shade800),
            onPressed: () => completer?.call(SheetResponse(confirmed: false)),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeToggle(BuildContext context, ConfirmSheetModel viewModel) {
    final sizes = request.data;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 10,
      ),
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        final size = sizes[index];
        final isSelected = viewModel.selectedSize == size.size.name;

        return ElevatedButton(
          onPressed: () {
            viewModel.setSize(size.size.name, size.id, size);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.black : Colors.white,
            side: const BorderSide(color: Colors.black),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "${size.size.name} (${size.size.grams}g)",
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  // Widget _buildIdToggle(BuildContext context, ConfirmSheetModel viewModel) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: List.generate(
  //       request.data.length,
  //       (index) {
  //         var size = request.data[index];
  //
  //         return ElevatedButton(
  //           onPressed: () {
  //             viewModel.setSize(size.size.name, size.id, size);
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: viewModel.selectedId == size.id ? Colors.black : Colors.white,
  //             side: const BorderSide(color: Colors.black),
  //             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //           child: Text(
  //             size.id.toString(),
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: viewModel.selectedId == size.id ? Colors.white : Colors.black,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildButton(BuildContext context, viewModel) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => viewModel.onAddPressed(
              context: context,
              completer: completer,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Přidat",
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  @override
  ConfirmSheetModel viewModelBuilder(BuildContext context) => ConfirmSheetModel();
}
