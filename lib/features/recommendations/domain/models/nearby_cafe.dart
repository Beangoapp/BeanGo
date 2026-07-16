import 'coffee_option.dart';

class NearbyCafe {
  const NearbyCafe({
    required this.id,
    required this.name,
    required this.distanceMeters,
    required this.estimatedPreparationMinutes,
    required this.menu,
    this.isOpen = true,
  });

  final String id;
  final String name;
  final int distanceMeters;
  final int estimatedPreparationMinutes;
  final List<CoffeeOption> menu;
  final bool isOpen;

  Iterable<CoffeeOption> get availableMenu =>
      menu.where((option) => option.isAvailable);
}
