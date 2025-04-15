// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/bonus_card/bonus_card_sheet.dart';
import '../ui/bottom_sheets/bonus_card_settings/bonus_card_settings_sheet.dart';
import '../ui/bottom_sheets/checkout/checkout_sheet.dart';
import '../ui/bottom_sheets/confirm/confirm_sheet.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';
import '../ui/bottom_sheets/user_data_missing/user_data_missing_sheet.dart';

enum BottomSheetType {
  notice,
  bonusCard,
  bonusCardSettings,
  userDataMissing,
  checkout,
  confirm,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.notice: (context, request, completer) =>
        NoticeSheet(request: request, completer: completer),
    BottomSheetType.bonusCard: (context, request, completer) =>
        BonusCardSheet(request: request, completer: completer),
    BottomSheetType.bonusCardSettings: (context, request, completer) =>
        BonusCardSettingsSheet(request: request, completer: completer),
    BottomSheetType.userDataMissing: (context, request, completer) =>
        UserDataMissingSheet(request: request, completer: completer),
    BottomSheetType.checkout: (context, request, completer) =>
        CheckoutSheet(request: request, completer: completer),
    BottomSheetType.confirm: (context, request, completer) =>
        ConfirmSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
