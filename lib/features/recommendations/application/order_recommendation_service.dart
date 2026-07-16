import '../domain/models/coffee_option.dart';
import '../domain/models/order_snapshot.dart';
import '../domain/models/recommendation.dart';

class OrderRecommendationService {
  const OrderRecommendationService({
    this.orderAgainWindow = const Duration(days: 30),
  });

  final Duration orderAgainWindow;

  Recommendation<CoffeeOption>? favorite(List<OrderSnapshot> orders) {
    final counts = <String, int>{};
    final options = <String, CoffeeOption>{};
    for (final order in orders.where((order) => order.completed)) {
      for (final item in order.items.where((item) => item.isAvailable)) {
        counts.update(item.id, (count) => count + 1, ifAbsent: () => 1);
        options[item.id] = item;
      }
    }
    if (counts.isEmpty) return null;
    final favoriteId = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    final count = counts[favoriteId]!;
    return Recommendation(
      source: RecommendationSource.favorite,
      reason: RecommendationReason.frequentChoice,
      value: options[favoriteId]!,
      score: (0.55 + count * .05).clamp(0, .95),
    );
  }

  Recommendation<OrderSnapshot>? orderAgain(
    List<OrderSnapshot> orders,
    DateTime now,
  ) {
    final eligible = orders.where((order) {
      final age = now.difference(order.orderedAt);
      return order.canOrderAgain && !age.isNegative && age <= orderAgainWindow;
    }).toList()..sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
    if (eligible.isEmpty) return null;
    return Recommendation(
      source: RecommendationSource.orderAgain,
      reason: RecommendationReason.recentOrder,
      value: eligible.first,
      score: .9,
    );
  }
}
