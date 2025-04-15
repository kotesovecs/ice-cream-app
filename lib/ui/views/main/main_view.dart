import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ice_cream/ui/views/history/history_view.dart';
import 'package:ice_cream/ui/views/settings/settings_view.dart';
import 'package:ice_cream/ui/views/todays_selection/todays_selection_view.dart';

import 'package:ice_cream/ui/widgets/common/custom_appbar/custom_appbar.dart';
import 'package:ice_cream/ui/widgets/common/custom_nav_bar/custom_nav_bar.dart';
import 'main_viewmodel.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(
    BuildContext context,
    MainViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: CustomAppbar(
            selectedIndex: viewModel.currentIndex,
            onIndexChanged: (index) {
              viewModel.setIndex(index);
              viewModel.animateToPage(index);
            },
          ),
        ),
        body: PageView(
          controller: viewModel.pageController,
          onPageChanged: viewModel.setIndex,
          children: const [
            TodaysSelectionView(),
            HistoryView(),
            SettingsView(),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: viewModel.currentIndex,
          onIndexChanged: (index) {
            viewModel.setIndex(index);
            viewModel.animateToPage(index);
          },
        ),
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}

Widget getViewForIndex(int index) {
  switch (index) {
    case 0:
      return const TodaysSelectionView();
    case 1:
      return const HistoryView();
    case 2:
      return const SettingsView();
    default:
      return const HistoryView();
  }
}
