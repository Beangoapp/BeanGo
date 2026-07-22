import 'package:beango/features/home/domain/entities/home_content.dart';
import 'package:beango/features/home/domain/services/home_recommendation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = HomeRecommendationService();
  const hot = HomeProduct(
    id: 'hot',
    nameKey: 'flatWhite',
    cafeName: 'Cafe',
    imageAsset: 'hot.png',
    price: 20,
    category: HomeCategoryType.hotCoffee,
  );
  const cold = HomeProduct(
    id: 'cold',
    nameKey: 'coldBrew',
    cafeName: 'Cafe',
    imageAsset: 'cold.png',
    price: 20,
    category: HomeCategoryType.icedCoffee,
  );

  test('prioritizes cold drinks during daytime heat hours', () {
    final result = service.recommend(
      products: const [hot, cold],
      orders: const [],
      now: DateTime(2026, 7, 22, 14),
    );

    expect(result.first.id, 'cold');
  });

  test('prioritizes previous orders', () {
    final result = service.recommend(
      products: const [hot, cold],
      orders: [
        HomeRecentOrder(
          id: '1',
          product: hot,
          orderedAt: DateTime(2026, 7, 20),
        ),
      ],
      now: DateTime(2026, 7, 22, 14),
    );

    expect(result.first.id, 'hot');
  });
}
