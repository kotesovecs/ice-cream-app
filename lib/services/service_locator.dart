import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}
