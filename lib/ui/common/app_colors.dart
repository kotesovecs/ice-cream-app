import 'package:flutter/material.dart';

const Color kcPrimaryColor = Color(0xFF9600FF);
const Color kcPrimaryColorDark = Color(0xFF300151);
const Color kcDarkGreyColor = Color(0xFF1A1B1E);
const Color kcMediumGrey = Color(0xFF474A54);
const Color kcLightGrey = Color.fromARGB(255, 187, 187, 187);
const Color kcVeryLightGrey = Color(0xFFE3E3E3);
//const Color kcBackgroundColor = Color(0xFFFDF8E8); //TODO do not delete this

const Color gradientColorFirst = Color(0xFFFFF6D5);
const Color gradientColorSecond = Color(0xFFFEE3A5);
const Color gradientColorThird = Color(0xFFA9935A);

const Color kcBackgroundColor = Color(0xFFFEE3A5);

final appTheme = ThemeData(
  //primaryColor: const Color(0xFFFF6600),
  primaryColor: const Color(0xFF000000),
  indicatorColor: const Color(0xFFFF6600),
  scaffoldBackgroundColor: Colors.transparent,
  colorScheme: _customColorScheme,
);

ColorScheme _customColorScheme = ColorScheme(
  //primary: const Color(0xFFFF6600),
  primary: const Color(0xFF000000),
  secondary: const Color(0Xfff2e5dc),
  tertiary: const Color(0xFF9E9E9E),
  surface: kcBackgroundColor,
  error: Colors.redAccent,
  onPrimary: Colors.white,
  onSecondary: const Color(0xFFFF6600),
  onSurface: Colors.grey.shade800,
  onError: Colors.white,
  brightness: Brightness.light,
  primaryContainer: Colors.black54,
  surfaceContainerHigh: const Color(0xFFFFF6D5),
  surfaceContainer: const Color(0xFFFEE3A5),
  surfaceContainerLow: const Color(0xFFA9935A),
);
