import 'dart:ui';

import 'package:beango/core/localization/locale_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('selects supported locales and rejects unsupported locales', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(localeControllerProvider.notifier)
        .select(const Locale('ar'));
    expect(container.read(localeControllerProvider), const Locale('ar'));

    container
        .read(localeControllerProvider.notifier)
        .select(const Locale('fr'));
    expect(container.read(localeControllerProvider), const Locale('ar'));
  });
}
