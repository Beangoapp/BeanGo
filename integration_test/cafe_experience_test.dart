import 'package:beango/core/theme/app_theme.dart';
import 'package:beango/features/cafe/application/cafe_providers.dart';
import 'package:beango/features/cafe/data/datasources/favorites_local_data_source.dart';
import 'package:beango/features/cafe/data/repositories/mock_cafe_repository.dart';
import 'package:beango/features/cafe/presentation/screens/cafe_details_screen.dart';
import 'package:beango/features/cafe/presentation/screens/product_details_screen.dart';
import 'package:beango/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens a cafe product and completes required customization', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/cafes/flat-white',
      routes: [
        GoRoute(
          path: '/cafes/:id',
          builder: (_, state) =>
              CafeDetailsScreen(cafeId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/products/:id',
          builder: (_, state) =>
              ProductDetailsScreen(productId: state.pathParameters['id']!),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cafeRepositoryProvider.overrideWithValue(
            const MockCafeRepository(delay: Duration.zero),
          ),
          favoritesDataSourceProvider.overrideWithValue(
            MemoryFavoritesDataSource(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cafe-product-product-1')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('product-details-screen')),
      findsOneWidget,
    );
  });
}
