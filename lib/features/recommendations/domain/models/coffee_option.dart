enum DrinkStyle { espresso, flatWhite, coldBrew, icedLatte, decaf }

class CoffeeOption {
  const CoffeeOption({
    required this.id,
    required this.cafeId,
    required this.name,
    required this.style,
    required this.price,
    this.isAvailable = true,
  });

  final String id;
  final String cafeId;
  final String name;
  final DrinkStyle style;
  final double price;
  final bool isAvailable;
}
