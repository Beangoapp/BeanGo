import 'package:beango/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows BeanGo branding then navigates to welcome', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BeanGoApp()));

    expect(find.text('BeanGo'), findsOneWidget);
    expect(find.text('YOUR COFFEE, YOUR MOMENT'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Your Coffee Knows You'), findsOneWidget);
  });
}
