enum HomeCategoryType {
  hotCoffee,
  icedCoffee,
  espresso,
  matcha,
  tea,
  desserts,
  bakery,
  breakfast,
}

class HomePromotion {
  const HomePromotion({
    required this.id,
    required this.titleKey,
    required this.bodyKey,
    required this.imageAsset,
  });

  final String id;
  final String titleKey;
  final String bodyKey;
  final String imageAsset;
}

class HomeCategory {
  const HomeCategory({required this.id, required this.type});

  final String id;
  final HomeCategoryType type;
}

class HomeCafe {
  const HomeCafe({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.rating,
    required this.distanceKm,
    required this.preparationMinutes,
    required this.isOpen,
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final String imageAsset;
  final double rating;
  final double distanceKm;
  final int preparationMinutes;
  final bool isOpen;
  final bool isFavorite;

  String get monogram =>
      String.fromCharCode(name.trim().runes.first).toUpperCase();

  HomeCafe copyWith({bool? isFavorite}) => HomeCafe(
    id: id,
    name: name,
    imageAsset: imageAsset,
    rating: rating,
    distanceKm: distanceKm,
    preparationMinutes: preparationMinutes,
    isOpen: isOpen,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}

class HomeProduct {
  const HomeProduct({
    required this.id,
    required this.nameKey,
    required this.cafeName,
    required this.imageAsset,
    required this.price,
    required this.category,
  });

  final String id;
  final String nameKey;
  final String cafeName;
  final String imageAsset;
  final double price;
  final HomeCategoryType category;

  String get heroTag => 'home-product-$id';
}

class HomeRecentOrder {
  const HomeRecentOrder({
    required this.id,
    required this.product,
    required this.orderedAt,
  });

  final String id;
  final HomeProduct product;
  final DateTime orderedAt;
}

class HomePage {
  const HomePage({
    required this.page,
    required this.hasMore,
    required this.promotions,
    required this.categories,
    required this.nearbyCafes,
    required this.featuredCafes,
    required this.trendingDrinks,
    required this.recentOrders,
    required this.recommendedProducts,
  });

  final int page;
  final bool hasMore;
  final List<HomePromotion> promotions;
  final List<HomeCategory> categories;
  final List<HomeCafe> nearbyCafes;
  final List<HomeCafe> featuredCafes;
  final List<HomeProduct> trendingDrinks;
  final List<HomeRecentOrder> recentOrders;
  final List<HomeProduct> recommendedProducts;
}

class HomeSearchResults {
  const HomeSearchResults({this.cafes = const [], this.products = const []});

  final List<HomeCafe> cafes;
  final List<HomeProduct> products;

  bool get isEmpty => cafes.isEmpty && products.isEmpty;
}
