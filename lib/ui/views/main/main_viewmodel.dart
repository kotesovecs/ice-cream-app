import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ice_cream/data_models/history_model.dart';

class MainViewModel extends IndexTrackingViewModel {
  late HistoryModel dataHistoryModel;
  final PageController pageController = PageController();

  void updateIndex(int index) {
    setIndex(index);
    notifyListeners();
  }

  void nextIndex() {
    int newIndex = (currentIndex + 1) % 3;
    setIndex(newIndex);
    animateToPage(newIndex);
  }

  void previousIndex() {
    int newIndex = (currentIndex - 1) < 0 ? 2 : (currentIndex - 1);
    setIndex(newIndex);
    animateToPage(newIndex);
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void jumpToPage(int index) {
    pageController.jumpToPage(
      index,
    );
  }
}
