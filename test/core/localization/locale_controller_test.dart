import 'dart:ui';

import 'package:beango/core/localization/locale_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('selects supported locales and saves the selection', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container
        .read(localeControllerProvider.notifier)
        .select(const Locale('ar'));
    expect(container.read(localeControllerProvider), const Locale('ar'));

    await container
        .read(localeControllerProvider.notifier)
        .select(const Locale('fr'));
    expect(container.read(localeControllerProvider), const Locale('ar'));

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('preferred_locale'), 'ar');
  });
}
