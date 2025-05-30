import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void setTheme(bool theme) {
    SessionManager.setTheme(theme);
    notifyListeners();
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: kBlackColor,
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryColorLight: kWhiteColor,
    primaryColorDark: kscafolledColor,
    hintColor: Colors.red,
    cardColor: Colors.red.shade200,
    highlightColor: kblueColor,
    dividerColor: kWhiteColor,
    fontFamily: 'Spline Sans',
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15.0),
      bodyMedium: TextStyle(
          color: kWhiteColor, fontWeight: FontWeight.w700, fontSize: 14.0),
      labelLarge: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Spline Sans',
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      displayLarge: TextStyle(
          fontFamily: 'Spline Sans',
          fontSize: 17.0,
          color: kWhiteColor,
          fontWeight: FontWeight.w600),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: kBlackColor),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(0xFF463D67, kColorsMap))
        .copyWith(background: k2BlackColor),
  );

  static final lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: kWhiteColor,
    brightness: Brightness.light,
    primaryColorDark: kWhiteColor,
    primaryColor: kBlackColor,
    primaryColorLight: kWhiteColor,
    hintColor: kblueColor,
    cardColor: kredColor,
    highlightColor: kblueColor,
    dividerColor: Colors.grey[200],
    fontFamily: 'Spline Sans',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w600, color: kWhiteColor, fontSize: 15.0),
      bodyMedium: TextStyle(
          color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 14.0),
      labelLarge: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Spline Sans',
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      displayLarge: TextStyle(
          fontFamily: 'Spline Sans',
          fontSize: 17.0,
          color: Colors.white,
          fontWeight: FontWeight.w600),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: kWhiteColor),
    colorScheme: ColorScheme.light().copyWith(
        onBackground: MaterialColor(0xFF557AFF, kColorsMap),
        background: kWhiteColor),
  );
}

Map<int, Color> kColorsMap = {
  50: const Color.fromRGBO(255, 92, 87, .1),
  100: const Color.fromRGBO(255, 92, 87, .2),
  200: const Color.fromRGBO(255, 92, 87, .3),
  300: const Color.fromRGBO(255, 92, 87, .4),
  400: const Color.fromRGBO(255, 92, 87, .5),
  500: const Color.fromRGBO(255, 92, 87, .6),
  600: const Color.fromRGBO(255, 92, 87, .7),
  700: const Color.fromRGBO(255, 92, 87, .8),
  800: const Color.fromRGBO(255, 92, 87, .9),
  900: const Color.fromRGBO(255, 92, 87, 1),
};
