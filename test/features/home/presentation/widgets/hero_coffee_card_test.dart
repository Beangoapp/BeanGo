import 'package:beango/core/theme/app_theme.dart';
import 'package:beango/features/home/presentation/widgets/hero_coffee_card.dart';
import 'package:beango/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the full-width English card and handles ordering', (
    tester,
  ) async {
    var orderCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 390,
            child: HeroCoffeeCard(
              coffeeName: 'Flat White',
              cafeName: 'BeanGo Café',
              readyMinutes: 4,
              onOrderAgain: () => orderCount++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(HeroCoffeeCard)).height, 336);
    expect(tester.getSize(find.byType(HeroCoffeeCard)).width, 390);
    expect(find.text('Flat White'), findsOneWidget);
    expect(find.text('BeanGo Café'), findsOneWidget);
    expect(find.text('Ready in 4 min'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(tester.getSize(find.byType(FilledButton)).height, 60);

    await tester.tap(find.text('Order Again'));
    expect(orderCount, 1);
  });

  testWidgets('supports Arabic RTL in dark mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: HeroCoffeeCard(
            coffeeName: 'فلات وايت',
            cafeName: 'مقهى بين جو',
            readyMinutes: 5,
            onOrderAgain: null,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      Directionality.of(tester.element(find.byType(HeroCoffeeCard))),
      TextDirection.rtl,
    );
    expect(find.text('جاهز خلال 5 دقائق'), findsOneWidget);
    expect(find.text('اطلب مرة أخرى'), findsOneWidget);
  });
}
