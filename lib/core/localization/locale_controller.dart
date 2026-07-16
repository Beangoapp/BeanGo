import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void select(Locale locale) {
    if (!const {'ar', 'en'}.contains(locale.languageCode)) return;
    state = Locale(locale.languageCode);
  }
}
