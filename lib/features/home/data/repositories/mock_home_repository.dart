import '../../domain/entities/home_content.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/services/home_recommendation_service.dart';

class MockHomeRepository implements HomeRepository {
  const MockHomeRepository({
    this.delay = const Duration(milliseconds: 650),
    this.failure,
    this.recommendationService = const HomeRecommendationService(),
  });

  final Duration delay;
  final HomeFailureType? failure;
  final HomeRecommendationService recommendationService;

  static const _promotions = [
    HomePromotion(
      id: 'coffee-tonic',
      titleKey: 'promoOne',
      bodyKey: 'promoOne',
      imageAsset: 'assets/images/promo_coffee_tonic.png',
    ),
    HomePromotion(
      id: 'coffee-pairing',
      titleKey: 'promoTwo',
      bodyKey: 'promoTwo',
      imageAsset: 'assets/images/promo_coffee_pairing.png',
    ),
    HomePromotion(
      id: 'morning-flat-white',
      titleKey: 'promoThree',
      bodyKey: 'promoThree',
      imageAsset: 'assets/images/flat_white.png',
    ),
  ];

  static const _categories = [
    HomeCategory(id: 'hot', type: HomeCategoryType.hotCoffee),
    HomeCategory(id: 'iced', type: HomeCategoryType.icedCoffee),
    HomeCategory(id: 'espresso', type: HomeCategoryType.espresso),
    HomeCategory(id: 'matcha', type: HomeCategoryType.matcha),
    HomeCategory(id: 'tea', type: HomeCategoryType.tea),
    HomeCategory(id: 'desserts', type: HomeCategoryType.desserts),
    HomeCategory(id: 'bakery', type: HomeCategoryType.bakery),
    HomeCategory(id: 'breakfast', type: HomeCategoryType.breakfast),
  ];

  static const _cafes = [
    HomeCafe(
      id: 'flat-white',
      name: 'Flat White',
      imageAsset: 'assets/images/coffee_beans.png',
      rating: 4.9,
      distanceKm: .6,
      preparationMinutes: 5,
      isOpen: true,
      isFavorite: true,
    ),
    HomeCafe(
      id: 'arabica',
      name: '% Arabica',
      imageAsset: 'assets/images/flat_white.png',
      rating: 4.8,
      distanceKm: 1.1,
      preparationMinutes: 7,
      isOpen: true,
    ),
    HomeCafe(
      id: 'earth',
      name: 'Earth Roastery',
      imageAsset: 'assets/images/cold_brew.png',
      rating: 4.8,
      distanceKm: 1.4,
      preparationMinutes: 8,
      isOpen: true,
    ),
    HomeCafe(
      id: 'volume',
      name: 'Volume Cafe',
      imageAsset: 'assets/images/croissant.png',
      rating: 4.7,
      distanceKm: 1.8,
      preparationMinutes: 9,
      isOpen: true,
    ),
    HomeCafe(
      id: 'caf',
      name: 'CAF',
      imageAsset: 'assets/images/iced_latte.png',
      rating: 4.7,
      distanceKm: 2.0,
      preparationMinutes: 6,
      isOpen: true,
    ),
    HomeCafe(
      id: 'halo',
      name: 'Halo',
      imageAsset: 'assets/images/cappuccino.png',
      rating: 4.6,
      distanceKm: 2.4,
      preparationMinutes: 10,
      isOpen: false,
    ),
    HomeCafe(
      id: 'espresso-lab',
      name: 'Espresso Lab',
      imageAsset: 'assets/images/americano.png',
      rating: 4.9,
      distanceKm: 2.8,
      preparationMinutes: 8,
      isOpen: true,
    ),
    HomeCafe(
      id: 'nomad',
      name: 'Nomad Coffee',
      imageAsset: 'assets/images/hero_coffee.png',
      rating: 4.6,
      distanceKm: 3.1,
      preparationMinutes: 11,
      isOpen: true,
    ),
    HomeCafe(
      id: 'roast',
      name: 'The Roast House',
      imageAsset: 'assets/images/empty_cup.png',
      rating: 4.5,
      distanceKm: 3.6,
      preparationMinutes: 12,
      isOpen: true,
    ),
  ];

  static const _products = [
    HomeProduct(
      id: 'spanish-latte',
      nameKey: 'spanishLatte',
      cafeName: 'Flat White',
      imageAsset: 'assets/images/spanish_latte.png',
      price: 24,
      category: HomeCategoryType.icedCoffee,
    ),
    HomeProduct(
      id: 'flat-white',
      nameKey: 'flatWhite',
      cafeName: '% Arabica',
      imageAsset: 'assets/images/flat_white.png',
      price: 22,
      category: HomeCategoryType.hotCoffee,
    ),
    HomeProduct(
      id: 'cold-brew',
      nameKey: 'coldBrew',
      cafeName: 'Earth Roastery',
      imageAsset: 'assets/images/cold_brew.png',
      price: 26,
      category: HomeCategoryType.icedCoffee,
    ),
    HomeProduct(
      id: 'cappuccino',
      nameKey: 'cappuccino',
      cafeName: 'Espresso Lab',
      imageAsset: 'assets/images/cappuccino.png',
      price: 21,
      category: HomeCategoryType.hotCoffee,
    ),
    HomeProduct(
      id: 'matcha-latte',
      nameKey: 'matchaLatte',
      cafeName: 'Volume Cafe',
      imageAsset: 'assets/images/matcha_latte.png',
      price: 27,
      category: HomeCategoryType.matcha,
    ),
    HomeProduct(
      id: 'pistachio-latte',
      nameKey: 'pistachioLatte',
      cafeName: 'CAF',
      imageAsset: 'assets/images/pistachio_latte.png',
      price: 29,
      category: HomeCategoryType.icedCoffee,
    ),
    HomeProduct(
      id: 'saffron-latte',
      nameKey: 'saffronLatte',
      cafeName: 'Halo',
      imageAsset: 'assets/images/saffron_latte.png',
      price: 30,
      category: HomeCategoryType.hotCoffee,
    ),
    HomeProduct(
      id: 'americano',
      nameKey: 'americano',
      cafeName: 'Earth Roastery',
      imageAsset: 'assets/images/americano.png',
      price: 18,
      category: HomeCategoryType.espresso,
    ),
    HomeProduct(
      id: 'chocolate-croissant',
      nameKey: 'chocolateCroissant',
      cafeName: 'Volume Cafe',
      imageAsset: 'assets/images/croissant.png',
      price: 19,
      category: HomeCategoryType.desserts,
    ),
  ];

  @override
  Future<HomePage> fetchHome({required int page, required int pageSize}) async {
    await Future<void>.delayed(delay);
    if (failure != null) throw HomeException(failure!);

    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, _cafes.length);
    final nearby = start >= _cafes.length
        ? const <HomeCafe>[]
        : _cafes.sublist(start, end);
    final recent = [
      HomeRecentOrder(
        id: 'order-1048',
        product: _products.first,
        orderedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    return HomePage(
      page: page,
      hasMore: end < _cafes.length,
      promotions: page == 0 ? _promotions : const [],
      categories: page == 0 ? _categories : const [],
      nearbyCafes: nearby,
      featuredCafes: page == 0 ? _cafes.take(3).toList() : const [],
      trendingDrinks: page == 0 ? _products : const [],
      recentOrders: page == 0 ? recent : const [],
      recommendedProducts: page == 0
          ? recommendationService.recommend(
              products: _products,
              orders: recent,
              now: DateTime.now(),
            )
          : const [],
    );
  }
}
