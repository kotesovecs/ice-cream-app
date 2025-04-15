import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ice_cream/ui/widgets/common/history_element/history_element.dart';
import 'history_viewmodel.dart';

class HistoryView extends StackedView<HistoryViewModel> {
  const HistoryView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HistoryViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final bool isHistoryEmpty = viewModel.objednavky == null || viewModel.objednavky!.isEmpty;

    if (isHistoryEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(indent: 80, endIndent: 80, color: Colors.grey),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: AutoSizeText(
                'Žádná historie nákupu',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                maxLines: 1,
              ),
            ),
            const Divider(indent: 80, endIndent: 80, color: Colors.grey),
            IconButton(
              onPressed: viewModel.loadData,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => viewModel.loadData(),
      child: ListView.builder(
        itemCount: viewModel.objednavky?.length,
        padding: const EdgeInsets.only(top: 70, bottom: 12),
        itemBuilder: (context, index) {
          final orderData = viewModel.objednavky?[viewModel.objednavky!.length - 1 - index];
          return HistoryElement(
            order: orderData,
          );
        },
      ),
    );
  }

  @override
  void onViewModelReady(HistoryViewModel viewModel) {
    viewModel.loadData();
  }

  @override
  HistoryViewModel viewModelBuilder(BuildContext context) => HistoryViewModel();
}
