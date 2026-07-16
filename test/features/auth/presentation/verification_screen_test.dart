import 'package:beango/features/auth/presentation/verification_screen.dart';
import 'package:beango/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('supports OTP autofill and resend countdown', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: VerificationScreen(phone: '+97455512345'),
        ),
      ),
    );
    await tester.pump();

    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.autofocus, isTrue);
    expect(find.textContaining('Resend code in'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
