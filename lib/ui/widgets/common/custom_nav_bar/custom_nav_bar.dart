import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'custom_nav_bar_model.dart';

class CustomNavBar extends StackedView<CustomNavBarModel> {
  const CustomNavBar({
    this.selectedIndex = 0,
    required this.onIndexChanged,
    super.key,
  });

  final int selectedIndex;
  final Function(int index) onIndexChanged;

  Widget _buildNavBarItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required IconData iconOutline,
    required CustomNavBarModel viewModel,
    bool showDot = false,
  }) {
    final isSelected = selectedIndex == index;
    return MaterialButton(
      onPressed: () {
        viewModel.setIndex(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? icon : iconOutline,
                  size: 28,
                  color: isSelected ? Colors.grey.shade900 : Colors.grey.shade600,
                ),
                if (showDot)
                  Positioned(
                    right: 0,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.grey.shade900 : Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget builder(BuildContext context, CustomNavBarModel viewModel, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            spreadRadius: 10,
            blurRadius: 14,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildNavBarItem(
                  context: context,
                  index: 0,
                  label: 'Nabídka',
                  icon: Icons.dashboard,
                  iconOutline: Icons.dashboard_outlined,
                  viewModel: viewModel,
                ),
                _buildNavBarItem(
                  context: context,
                  index: 1,
                  label: 'Objednávky',
                  icon: Icons.access_time_filled,
                  iconOutline: Icons.access_time_outlined,
                  viewModel: viewModel,
                  showDot: viewModel.readyOrder,
                ),
                _buildNavBarItem(
                  context: context,
                  index: 2,
                  label: 'Nastavení',
                  icon: Icons.settings,
                  iconOutline: Icons.settings_outlined,
                  viewModel: viewModel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  CustomNavBarModel viewModelBuilder(BuildContext context) => CustomNavBarModel(notifyMainViewModel: onIndexChanged);
}
