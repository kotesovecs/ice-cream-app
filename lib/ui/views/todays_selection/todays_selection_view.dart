import 'package:ZmrzlinaApi/api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_cream/app/provider/cart_provider.dart';
import 'package:ice_cream/ui/widgets/common/circular_button/circular_button.dart';
import 'package:ice_cream/ui/widgets/common/action_button/action_button.dart';
import 'package:ice_cream/ui/widgets/common/day_card/day_card.dart';

import 'todays_selection_viewmodel.dart';

class TodaysSelectionView extends StackedView<TodaysSelectionViewModel> {
  const TodaysSelectionView({super.key});

  @override
  Widget builder(
    BuildContext context,
    TodaysSelectionViewModel viewModel,
    Widget? child,
  ) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.areAllCategoriesEmpty) {
          return _buildErrorView(viewModel);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              const Gap(50),
              DayCard(data: viewModel.dailyMenu),
              const Gap(12),
              Text(viewModel.dailyMenu!.note ?? "", style: const TextStyle(color: Colors.black, fontSize: 16)),
              const Gap(12),
              _buildActionButtons(viewModel, context),
              ...viewModel.categoriesMap.entries.map((entry) {
                final categoryName = entry.key;
                final categoryItems = entry.value;

                if (categoryItems.isEmpty) {
                  return const SizedBox.shrink();
                }

                return _buildCategory(categoryName, categoryItems, viewModel);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorView(TodaysSelectionViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(color: Colors.grey),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Dnes není žádná nabídka nebo se vyskytl problém. Zkontrolujte svoje připojení a zkuste to znovu nebo později.",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(color: Colors.grey),
            IconButton(
              onPressed: () => viewModel.reloadData(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(TodaysSelectionViewModel viewModel, BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    final hasItemsInCart = cartProvider.orderedVariantList.isNotEmpty;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ActionButton(
          title: 'Kartička',
          icon: Icons.qr_code_2,
          active: true,
          onTap: viewModel.openBonusCard,
        ),
        const Gap(10),
        ActionButton(
          title: 'Košík',
          icon: Icons.shopping_cart,
          active: hasItemsInCart,
          onTap: () {
            if (hasItemsInCart) {
              viewModel.navigateToCheckout(context);
            } else {
              Fluttertoast.showToast(
                  msg: "Váš košík je prázdný.", gravity: ToastGravity.CENTER, backgroundColor: Colors.grey);
            }
          },
        ),
      ],
    );
  }

  Widget _buildCategory(
      String title, List<DailyMenuDtoItemsValueItemsInner> items, TodaysSelectionViewModel viewModel) {
    if (viewModel.isCategoryEmpty(items)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 26, bottom: 22),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                fontSize: 22,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: AutoSizeText(
              "Žádné položky k zobrazení.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 26, bottom: 22),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
              fontSize: 22,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 26,
            mainAxisSpacing: 26,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final price = item.sizes.isNotEmpty ? item.sizes.first.price : 'N/A';
            final isInactive = viewModel.isPastOrder();
            return CircularButton(
              title: item.name,
              accept: true,
              inactive: isInactive,
              sizes: item.sizes,
              onTap: () async {
                if (viewModel.isPastOrder()) {
                  if (context.mounted) {
                    Fluttertoast.showToast(
                        msg: "Nyní nelze objednávat.", gravity: ToastGravity.CENTER, backgroundColor: Colors.grey);
                  }
                  return;
                }

                final response = await viewModel.showConfirmationBottomSheet(
                  title: item.name,
                  description: "$price,-",
                  data: item.sizes,
                );

                if (response?.confirmed == true) {
                  // if (context.mounted) {
                  //   final cupProvider = Provider.of<CupProvider>(context, listen: false);
                  //   cupProvider.addCup(item);
                  //
                  //   final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  //   cartProvider.addNOfVariant(item.id, 1);
                  // print(item.id);
                  // }
                }
              },
            );
          },
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  @override
  TodaysSelectionViewModel viewModelBuilder(BuildContext context) => TodaysSelectionViewModel();
}
