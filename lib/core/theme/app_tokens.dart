import 'package:flutter/animation.dart';

export 'app_radius.dart';
export 'app_spacing.dart';

abstract final class AppMotion {
  static const standard = Duration(milliseconds: 240);
  static const emphasized = Duration(milliseconds: 320);
  static const enterCurve = Curves.easeOut;
  static const transitionCurve = Curves.easeInOut;
}
