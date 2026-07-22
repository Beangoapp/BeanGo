import 'package:beango/core/theme/app_theme.dart';
import 'package:beango/features/authentication/data/datasources/auth_preferences.dart';
import 'package:beango/features/authentication/data/datasources/session_storage.dart';
import 'package:beango/features/authentication/presentation/controllers/authentication_controller.dart';
import 'package:beango/features/home/application/home_providers.dart';
import 'package:beango/features/home/data/repositories/mock_home_repository.dart';
import 'package:beango/features/home/domain/repositories/home_repository.dart';
import 'package:beango/features/home/presentation/home_screen.dart';
import 'package:beango/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget app({
    Locale locale = const Locale('en'),
    HomeRepository repository = const MockHomeRepository(delay: Duration.zero),
  }) => ProviderScope(
    overrides: [
      homeRepositoryProvider.overrideWithValue(repository),
      sessionStorageProvider.overrideWithValue(MemorySessionStorage()),
      authPreferencesProvider.overrideWithValue(
        MemoryAuthPreferences(completed: true),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    ),
  );

  testWidgets('renders the premium home hierarchy', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home-header')), findsOneWidget);
    expect(find.text('BeanGo'), findsOneWidget);
    final location = tester.widget<Text>(
      find.byKey(const ValueKey('home-current-location')),
    );
    expect(location.data, 'West Bay, Doha');
    final locationLabel = tester.widget<Text>(
      find.byKey(const ValueKey('home-delivery-location-label')),
    );
    expect(locationLabel.data, 'Delivery location');
    expect(find.byKey(const ValueKey('home-search-field')), findsOneWidget);
    final searchHint = tester.widget<Text>(
      find.byKey(const ValueKey('home-search-hint-0')),
    );
    expect(searchHint.data, 'Search cafés');
    final homeScroll = find
        .descendant(
          of: find.byType(CustomScrollView),
          matching: find.byType(Scrollable),
        )
        .first;
    for (final sectionKey in const [
      ValueKey('home-section-promotions'),
      ValueKey('home-section-categories'),
      ValueKey('home-section-nearby'),
      ValueKey('home-section-featured'),
      ValueKey('home-section-trending'),
      ValueKey('home-section-recently-ordered'),
      ValueKey('home-section-recommended'),
    ]) {
      final section = find.byKey(sectionKey);
      await tester.scrollUntilVisible(section, 320, scrollable: homeScroll);
      await tester.pump(const Duration(milliseconds: 350));
      expect(section, findsOneWidget);
    }
  });

  testWidgets('filters cafés using the search field', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('home-search-field')),
      'Arabica',
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const ValueKey('home-section-search-results')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('home-search-result-cafe-arabica')),
      findsOneWidget,
    );
  });

  testWidgets('supports Arabic RTL and dark mode', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(app(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(
        tester.element(find.byKey(const ValueKey('home-screen'))),
      ),
      TextDirection.rtl,
    );
    expect(
      Theme.of(
        tester.element(find.byKey(const ValueKey('home-screen'))),
      ).brightness,
      Brightness.dark,
    );
    final location = tester.widget<Text>(
      find.byKey(const ValueKey('home-current-location')),
    );
    expect(location.data, 'الخليج الغربي، الدوحة');
    final locationLabel = tester.widget<Text>(
      find.byKey(const ValueKey('home-delivery-location-label')),
    );
    expect(locationLabel.data, 'موقع التوصيل');
    final searchHint = tester.widget<Text>(
      find.byKey(const ValueKey('home-search-hint-0')),
    );
    expect(searchHint.data, 'ابحث عن مقهى');
    expect(
      Directionality.of(
        tester.element(find.byKey(const ValueKey('home-search-field'))),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets('renders offline and retry state', (tester) async {
    await tester.pumpWidget(
      app(
        repository: const MockHomeRepository(
          delay: Duration.zero,
          failure: HomeFailureType.offline,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("You're offline"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
