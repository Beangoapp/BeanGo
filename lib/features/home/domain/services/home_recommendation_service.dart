import '../entities/home_content.dart';

class HomeRecommendationService {
  const HomeRecommendationService();

  List<HomeProduct> recommend({
    required List<HomeProduct> products,
    required List<HomeRecentOrder> orders,
    required DateTime now,
    int limit = 5,
  }) {
    final orderedIds = orders.map((order) => order.product.id).toSet();
    final prefersCold = now.hour >= 11 && now.hour < 19;
    final ranked = [...products]
      ..sort((left, right) {
        int score(HomeProduct product) {
          var value = orderedIds.contains(product.id) ? 4 : 0;
          if (prefersCold &&
              {
                HomeCategoryType.icedCoffee,
                HomeCategoryType.matcha,
              }.contains(product.category)) {
            value += 2;
          }
          if (!prefersCold &&
              {
                HomeCategoryType.hotCoffee,
                HomeCategoryType.espresso,
              }.contains(product.category)) {
            value += 2;
          }
          return value;
        }

        final comparison = score(right).compareTo(score(left));
        return comparison != 0 ? comparison : left.id.compareTo(right.id);
      });
    return List.unmodifiable(ranked.take(limit));
  }
}
