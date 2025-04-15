import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_cream/app/app.bottomsheets.dart';
import 'package:ice_cream/app/app.dialogs.dart';
import 'package:ice_cream/app/app.locator.dart';
import 'package:ice_cream/app/app.router.dart';
import 'package:ice_cream/app/provider/cup_provider.dart';
import 'package:ice_cream/app/provider/order_provider.dart';
import 'package:ice_cream/ui/common/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:ice_cream/services/push_notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/provider/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CupProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    PushNotificationService.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1,
              colors: [
                Color(0xFFFFF6D5),
                Color(0xFFFEE3A5),
                Color(0xFFA9935A),
              ],
              stops: [0.2, 0.7, 8.0],
            ),
          ),
          child: child,
        );
      },
    );
  }
}
