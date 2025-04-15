import 'package:stacked/stacked.dart';

class HistoryElementModel extends BaseViewModel {
  bool isDetail = false;
  bool isNoteExpanded = false;

  void toggle() {
    isDetail = !isDetail;
    notifyListeners();
  }

  void toggleNoteExpanded() {
    isNoteExpanded = !isNoteExpanded;
    notifyListeners();
  }
}
