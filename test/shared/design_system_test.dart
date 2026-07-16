import 'package:beango/core/theme/app_colors.dart';
import 'package:beango/core/theme/app_radius.dart';
import 'package:beango/core/theme/app_spacing.dart';
import 'package:beango/core/theme/app_typography.dart';
import 'package:beango/shared/widgets/app_buttons.dart';
import 'package:beango/shared/widgets/app_cards.dart';
import 'package:beango/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('design tokens match the approved specification', () {
    expect(AppColors.espresso, const Color(0xFF2B1D16));
    expect(AppSpacing.lg, 24);
    expect(AppRadius.hero, 28);
    expect(AppTypography.display.fontSize, 40);
  });

  testWidgets('shared controls are reusable and interactive', (tester) async {
    final controller = TextEditingController();
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AppTextField(controller: controller, label: 'Phone'),
              AppButton(label: 'Continue', onPressed: () => taps++),
              const AppCard(child: Text('Card content')),
            ],
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '5551234');
    await tester.tap(find.text('Continue'));

    expect(controller.text, '5551234');
    expect(taps, 1);
    expect(find.text('Card content'), findsOneWidget);
  });
}
