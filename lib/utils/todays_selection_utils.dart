import 'package:ZmrzlinaApi/api.dart';

Map<String, List<DailyMenuDtoItemsValueItemsInner>> filterCategories(
    Map<String, List<String>> categoryNames, DailyMenuDto? dailyMenu) {
  if (dailyMenu?.items == null) return {};

  return categoryNames.map((key, names) {
    return MapEntry(
      key,
      dailyMenu!.items.values
          .where((category) => names.contains(category.name.toLowerCase()))
          .expand<DailyMenuDtoItemsValueItemsInner>(
              (category) => category.items.cast<DailyMenuDtoItemsValueItemsInner>()) // Explicit casting
          .toList(),
    );
  });
}

Map<String, List<DailyMenuDtoItemsValueItemsInnerSizesInner>> filterCategoryPrices(
    Map<String, String> categoryNames, DailyMenuDto? dailyMenu) {
  if (dailyMenu?.items == null) return {};

  return categoryNames.map((key, name) {
    return MapEntry(
      key,
      dailyMenu!.items.values
          .where((category) => category.name == name)
          .expand<DailyMenuDtoItemsValueItemsInner>(
              (category) => category.items.cast<DailyMenuDtoItemsValueItemsInner>()) // Explicit casting
          .expand<DailyMenuDtoItemsValueItemsInnerSizesInner>(
              (item) => item.sizes.cast<DailyMenuDtoItemsValueItemsInnerSizesInner>()) // Explicit casting
          .toList(),
    );
  });
}
