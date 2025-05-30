import 'package:flutter/material.dart';

class SizeConfig {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static double width() {
    return MediaQuery.of(navigatorKey.currentState!.context).size.width;
  }

  static double height() {
    return MediaQuery.of(navigatorKey.currentState!.context).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(navigatorKey.currentState!.context).size.width / 100.0;
  }

  static double screenHeight() {
    return MediaQuery.of(navigatorKey.currentState!.context).size.height / 100.0;
  }
}
