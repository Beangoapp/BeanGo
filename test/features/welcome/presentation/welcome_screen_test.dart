import 'package:beango/features/welcome/presentation/welcome_screen.dart';
import 'package:beango/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the approved welcome experience', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WelcomeScreen(),
      ),
    );

    expect(find.text('Your Coffee Knows You'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Language'), findsNothing);
    expect(find.byType(PageView), findsNothing);
  });
}
