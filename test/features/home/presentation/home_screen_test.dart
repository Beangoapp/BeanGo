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

    expect(find.text('BeanGo'), findsOneWidget);
    expect(find.text('West Bay, Doha'), findsOneWidget);
    expect(find.text('Search cafés'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Nearby cafés'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Featured cafés'), findsOneWidget);
    expect(find.text('Trending drinks'), findsOneWidget);
  });

  testWidgets('filters cafés using the search field', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Arabica');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Search results'), findsOneWidget);
    expect(find.text('% Arabica'), findsOneWidget);
  });

  testWidgets('supports Arabic RTL and dark mode', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(app(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(HomeScreen))),
      TextDirection.rtl,
    );
    expect(find.text('الخليج الغربي، الدوحة'), findsOneWidget);
    expect(find.text('ابحث عن مقهى'), findsOneWidget);
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
