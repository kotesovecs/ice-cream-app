import 'package:ice_cream/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:ice_cream/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:ice_cream/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:ice_cream/ui/views/main/main_view.dart';
import 'package:ice_cream/ui/views/history/history_view.dart';
import 'package:ice_cream/ui/views/todays_selection/todays_selection_view.dart';
import 'package:ice_cream/ui/views/settings/settings_view.dart';
import 'package:ice_cream/ui/bottom_sheets/bonus_card/bonus_card_sheet.dart';
import 'package:ice_cream/ui/bottom_sheets/bonus_card_settings/bonus_card_settings_sheet.dart';
import 'package:ice_cream/ui/views/checkout/checkout_view.dart';
import 'package:ice_cream/ui/bottom_sheets/user_data_missing/user_data_missing_sheet.dart';
import 'package:ice_cream/ui/bottom_sheets/checkout/checkout_sheet.dart';
import 'package:ice_cream/ui/bottom_sheets/confirm/confirm_sheet.dart';
import 'package:ice_cream/services/data_storage_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: MainView),
    MaterialRoute(page: HistoryView),
    MaterialRoute(page: TodaysSelectionView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: CheckoutView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DataStorageService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: BonusCardSheet),
    StackedBottomsheet(classType: BonusCardSettingsSheet),
    StackedBottomsheet(classType: UserDataMissingSheet),
    StackedBottomsheet(classType: CheckoutSheet),
    StackedBottomsheet(classType: ConfirmSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
