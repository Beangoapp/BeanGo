import 'coffee_option.dart';

class OrderSnapshot {
  const OrderSnapshot({
    required this.id,
    required this.orderedAt,
    required this.items,
    required this.total,
    this.completed = true,
  });

  final String id;
  final DateTime orderedAt;
  final List<CoffeeOption> items;
  final double total;
  final bool completed;

  bool get canOrderAgain =>
      completed && items.isNotEmpty && items.every((item) => item.isAvailable);
}
