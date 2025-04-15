import 'package:intl/date_symbol_data_local.dart';
import 'package:stacked/stacked.dart';

class DayCardModel extends BaseViewModel {
  Future<void> initDateFormatting() async {
    await initializeDateFormatting('cs');
  }
}
