import 'package:beango/core/theme/app_theme.dart';
import 'package:beango/features/cafe/application/cafe_providers.dart';
import 'package:beango/features/cafe/data/datasources/favorites_local_data_source.dart';
import 'package:beango/features/cafe/data/repositories/mock_cafe_repository.dart';
import 'package:beango/features/cafe/presentation/screens/cafe_details_screen.dart';
import 'package:beango/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget app({Locale locale = const Locale('en')}) => ProviderScope(
    overrides: [
      cafeRepositoryProvider.overrideWithValue(
        const MockCafeRepository(delay: Duration.zero),
      ),
      favoritesDataSourceProvider.overrideWithValue(
        MemoryFavoritesDataSource(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CafeDetailsScreen(cafeId: 'flat-white'),
    ),
  );

  testWidgets('renders premium cafe details, sticky categories and products', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('cafe-details-screen')), findsOneWidget);
    expect(find.text('Flat White'), findsWidgets);
    expect(find.byKey(const ValueKey('cafe-category-tabs')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('cafe-product-product-1')),
      findsOneWidget,
    );
  });

  testWidgets('supports Arabic RTL and dark mode', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(app(locale: const Locale('ar')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final screen = find.byKey(const ValueKey('cafe-details-screen'));
    expect(Directionality.of(tester.element(screen)), TextDirection.rtl);
    expect(Theme.of(tester.element(screen)).brightness, Brightness.dark);
    expect(find.text('الأكثر طلبًا'), findsOneWidget);
    await tester.tap(find.text('قهوة ساخنة'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey('cafe-product-product-2')),
      findsOneWidget,
    );
  });
}
