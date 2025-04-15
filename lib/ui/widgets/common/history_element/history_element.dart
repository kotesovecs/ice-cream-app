import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:ice_cream/ui/widgets/common/history_element/history_element_model.dart';

class HistoryElement extends StackedView<HistoryElementModel> {
  final OrderDto? order;

  const HistoryElement({super.key, required this.order});

  static const _animationDuration = 200;

  @override
  Widget builder(
    BuildContext context,
    HistoryElementModel viewModel,
    Widget? child,
  ) {
    return GestureDetector(
      onTap: viewModel.toggle,
      child: AnimatedContainer(
        height: viewModel.isDetail ? null : 126,
        duration: const Duration(milliseconds: _animationDuration),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 14,
              offset: const Offset(0, 1.1),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(viewModel.isDetail),
                  _buildStatusTag(context, viewModel.isDetail),
                ],
              ),
              const SizedBox(height: 10),
              _buildDetailSection(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDetail) {
    final createdAt = order?.createdAt;
    DateTime? dateTime = createdAt is String ? DateTime.tryParse(createdAt) : createdAt as DateTime?;
    final formattedDate = dateTime != null ? DateFormat('dd. MM. yy').format(dateTime) : '';
    final itemCount = order?.polozky.fold<int>(0, (sum, item) => sum + (item.quantity.toInt())) ?? 0;
    final polozkyText = itemCount == 1 ? 'kus' : (itemCount < 5 ? 'kusy' : 'kusů');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Colors.grey.shade800,
            ),
          ),
          Row(
            children: [
              if (!isDetail)
                Text(
                  '$itemCount $polozkyText',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              if (!isDetail) const SizedBox(width: 25),
              Text(
                '#${order?.id}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(HistoryElementModel viewModel) {
    return AnimatedOpacity(
      opacity: viewModel.isDetail ? 1.0 : 0.0,
      duration: const Duration(milliseconds: _animationDuration),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemList(),
          const SizedBox(height: 15),
          if (order?.note != null && order!.note!.isNotEmpty) _buildNoteSection(viewModel),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cena celkem:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${order?.totalPrice},-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(HistoryElementModel viewModel) {
    if (order?.note == null || order!.note!.isEmpty) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        viewModel.toggleNoteExpanded();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Poznámka:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              order!.note!,
              maxLines: viewModel.isNoteExpanded ? 100 : 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: ListView.builder(
        itemCount: order?.polozky.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          final item = order?.polozky[index];
          final totalPrice = (item?.polozka.price ?? 0) * (item?.quantity ?? 0);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item?.polozka.polozka.name ?? ''),
                const Gap(10),
                Text('(${item?.polozka.velikost.name})'),
                const Expanded(child: SizedBox()),
                Text('${item?.quantity} ks'),
                const Expanded(child: SizedBox()),
                Text('$totalPrice,-'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context, bool isDetail) {
    Color statusColor;
    String statusText;

    if (order?.orderState.value == OrderDtoOrderStateEnum.vychystane.value) {
      statusColor = Colors.green;
      statusText = "Připraveno";
    } else if (order?.orderState.value == OrderDtoOrderStateEnum.vydane.value) {
      statusColor = Colors.grey;
      statusText = "Vydáno";
    } else {
      statusColor = Theme.of(context).primaryColor;
      statusText = "Nová";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isDetail)
          Text(
            '${order?.totalPrice},-',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Colors.grey.shade800,
            ),
          ),
        if (!isDetail) const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: statusColor,
          ),
          child: SizedBox(
            width: 120,
            child: Text(
              statusText,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  HistoryElementModel viewModelBuilder(BuildContext context) => HistoryElementModel();
}
