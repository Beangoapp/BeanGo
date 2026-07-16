import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale?> {
  static const _localeKey = 'preferred_locale';

  @override
  Locale? build() {
    Future<void>.microtask(_restore);
    return null;
  }

  Future<void> select(Locale locale) async {
    if (!const {'ar', 'en'}.contains(locale.languageCode)) return;
    state = Locale(locale.languageCode);
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_localeKey, locale.languageCode);
    } catch (_) {
      // The selected locale remains active even if persistence is unavailable.
    }
  }

  Future<void> _restore() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final languageCode = preferences.getString(_localeKey);
      if (languageCode != null && const {'ar', 'en'}.contains(languageCode)) {
        state = Locale(languageCode);
      }
    } catch (_) {
      // The platform locale remains the fallback.
    }
  }
}
