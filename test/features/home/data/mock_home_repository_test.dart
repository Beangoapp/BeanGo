import 'package:beango/features/home/data/repositories/mock_home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = MockHomeRepository(delay: Duration.zero);

  test('returns complete first page and paginates nearby cafes', () async {
    final first = await repository.fetchHome(page: 0, pageSize: 3);
    final second = await repository.fetchHome(page: 1, pageSize: 3);

    expect(first.promotions, hasLength(3));
    expect(first.categories, hasLength(8));
    expect(first.nearbyCafes, hasLength(3));
    expect(first.featuredCafes, isNotEmpty);
    expect(first.trendingDrinks, isNotEmpty);
    expect(first.recentOrders, isNotEmpty);
    expect(first.recommendedProducts, isNotEmpty);
    expect(first.hasMore, isTrue);

    expect(second.nearbyCafes, hasLength(3));
    expect(second.promotions, isEmpty);
    expect(
      second.nearbyCafes
          .map((cafe) => cafe.id)
          .toSet()
          .intersection(first.nearbyCafes.map((cafe) => cafe.id).toSet()),
      isEmpty,
    );
  });
}
