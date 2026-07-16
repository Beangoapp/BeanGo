import 'package:flutter/animation.dart';

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;
  static const xxxl = 48.0;
  static const huge = 64.0;
}

abstract final class AppRadius {
  static const control = 12.0;
  static const input = 16.0;
  static const card = 20.0;
  static const hero = 28.0;
  static const pill = 999.0;
}

abstract final class AppMotion {
  static const standard = Duration(milliseconds: 240);
  static const emphasized = Duration(milliseconds: 320);
  static const enterCurve = Curves.easeOut;
  static const transitionCurve = Curves.easeInOut;
}
