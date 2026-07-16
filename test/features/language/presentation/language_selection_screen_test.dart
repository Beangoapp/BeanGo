import 'package:beango/features/language/presentation/language_selection_screen.dart';
import 'package:beango/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('offers English and Arabic', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LanguageSelectionScreen(),
        ),
      ),
    );

    expect(find.text('English'), findsWidgets);
    expect(find.text('العربية'), findsOneWidget);

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    final selected = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Arabic',
      ),
    );
    expect(selected.properties.selected, isTrue);
  });
}
