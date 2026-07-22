import 'package:beango/app/app.dart';
import 'package:beango/features/authentication/data/datasources/auth_preferences.dart';
import 'package:beango/features/authentication/data/datasources/session_storage.dart';
import 'package:beango/features/authentication/presentation/controllers/authentication_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows BeanGo branding then navigates to onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStorageProvider.overrideWithValue(MemorySessionStorage()),
          authPreferencesProvider.overrideWithValue(MemoryAuthPreferences()),
        ],
        child: const BeanGoApp(),
      ),
    );

    expect(find.text('BeanGo'), findsOneWidget);
    expect(find.text('YOUR COFFEE, YOUR MOMENT'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Coffee that knows you'), findsOneWidget);
  });
}
