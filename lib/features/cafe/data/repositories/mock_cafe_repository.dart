import '../../domain/entities/cafe_entities.dart';
import '../../domain/repositories/cafe_repository.dart';

class MockCafeRepository implements CafeRepository {
  const MockCafeRepository({
    this.delay = const Duration(milliseconds: 500),
    this.failure,
  });

  final Duration delay;
  final CafeFailureType? failure;

  static const _assets = [
    'assets/images/spanish_latte.png',
    'assets/images/flat_white.png',
    'assets/images/cold_brew.png',
    'assets/images/cappuccino.png',
    'assets/images/matcha_latte.png',
    'assets/images/pistachio_latte.png',
    'assets/images/saffron_latte.png',
    'assets/images/americano.png',
    'assets/images/croissant.png',
    'assets/images/iced_latte.png',
  ];

  static const _cafeNames = [
    'Flat White',
    '% Arabica',
    'Earth Roastery',
    'Volume Cafe',
    'CAF',
    'Halo',
    'Espresso Lab',
    'Nomad Coffee',
    'The Roast House',
    'Origin',
  ];
  static const _cafeIds = [
    'flat-white',
    'arabica',
    'earth',
    'volume',
    'caf',
    'halo',
    'espresso-lab',
    'nomad',
    'roast',
    'origin',
  ];

  static final cafes = List<CafeSummary>.generate(
    10,
    (index) => CafeSummary(
      id: _cafeIds[index],
      name: _cafeNames[index],
      heroImage: _assets[index],
      logoImage: index.isEven
          ? 'assets/images/coffee_beans.png'
          : 'assets/images/empty_cup.png',
      rating: 4.5 + (index % 5) / 10,
      distanceKm: .5 + index * .35,
      preparationMinutes: 4 + index,
      isOpen: index != 8,
      openingHours: index == 8 ? '07:00 – 18:00' : '06:00 – 23:00',
    ),
  );

  static const optionGroups = [
    ProductOptionGroup(
      id: 'size',
      name: 'Size',
      nameAr: 'الحجم',
      type: SelectionType.single,
      minSelections: 1,
      maxSelections: 1,
      options: [
        ProductOption(id: 'small', name: 'Small', nameAr: 'صغير'),
        ProductOption(
          id: 'medium',
          name: 'Medium',
          nameAr: 'وسط',
          extraPrice: 3,
        ),
        ProductOption(
          id: 'large',
          name: 'Large',
          nameAr: 'كبير',
          extraPrice: 5,
        ),
      ],
    ),
    ProductOptionGroup(
      id: 'milk',
      name: 'Milk',
      nameAr: 'الحليب',
      type: SelectionType.single,
      minSelections: 1,
      maxSelections: 1,
      options: [
        ProductOption(id: 'whole', name: 'Whole milk', nameAr: 'حليب كامل'),
        ProductOption(
          id: 'oat',
          name: 'Oat milk',
          nameAr: 'حليب شوفان',
          extraPrice: 4,
        ),
        ProductOption(
          id: 'almond',
          name: 'Almond milk',
          nameAr: 'حليب لوز',
          extraPrice: 4,
        ),
      ],
    ),
    ProductOptionGroup(
      id: 'sugar',
      name: 'Sugar level',
      nameAr: 'مستوى السكر',
      type: SelectionType.single,
      minSelections: 0,
      maxSelections: 1,
      options: [
        ProductOption(id: 'none', name: 'No sugar', nameAr: 'بدون سكر'),
        ProductOption(id: 'regular', name: 'Regular', nameAr: 'عادي'),
        ProductOption(id: 'sweet', name: 'Sweet', nameAr: 'حلو'),
      ],
    ),
    ProductOptionGroup(
      id: 'ice',
      name: 'Ice level',
      nameAr: 'مستوى الثلج',
      type: SelectionType.single,
      minSelections: 0,
      maxSelections: 1,
      options: [
        ProductOption(id: 'light-ice', name: 'Light ice', nameAr: 'ثلج خفيف'),
        ProductOption(
          id: 'regular-ice',
          name: 'Regular ice',
          nameAr: 'ثلج عادي',
        ),
        ProductOption(id: 'extra-ice', name: 'Extra ice', nameAr: 'ثلج إضافي'),
      ],
    ),
    ProductOptionGroup(
      id: 'shots',
      name: 'Espresso shots',
      nameAr: 'جرعات الإسبريسو',
      type: SelectionType.single,
      minSelections: 0,
      maxSelections: 1,
      options: [
        ProductOption(id: 'one-shot', name: 'One shot', nameAr: 'جرعة واحدة'),
        ProductOption(
          id: 'two-shots',
          name: 'Two shots',
          nameAr: 'جرعتان',
          extraPrice: 4,
        ),
        ProductOption(
          id: 'three-shots',
          name: 'Three shots',
          nameAr: 'ثلاث جرعات',
          extraPrice: 7,
        ),
      ],
    ),
    ProductOptionGroup(
      id: 'addons',
      name: 'Add-ons',
      nameAr: 'الإضافات',
      type: SelectionType.multiple,
      minSelections: 0,
      maxSelections: 2,
      options: [
        ProductOption(
          id: 'vanilla',
          name: 'Vanilla',
          nameAr: 'فانيلا',
          extraPrice: 3,
        ),
        ProductOption(
          id: 'caramel',
          name: 'Caramel',
          nameAr: 'كراميل',
          extraPrice: 3,
        ),
        ProductOption(
          id: 'cream',
          name: 'Whipped cream',
          nameAr: 'كريمة',
          extraPrice: 4,
        ),
      ],
    ),
  ];

  static final products = List<CafeProduct>.generate(100, (index) {
    const names = [
      'Spanish Latte',
      'Flat White',
      'Cold Brew',
      'Cappuccino',
      'Matcha Latte',
      'Pistachio Latte',
      'Saffron Latte',
      'Americano',
      'Chocolate Croissant',
      'Iced Latte',
    ];
    const namesAr = [
      'سبانش لاتيه',
      'فلات وايت',
      'كولد برو',
      'كابتشينو',
      'ماتشا لاتيه',
      'بيستاشيو لاتيه',
      'زعفران لاتيه',
      'أمريكانو',
      'كرواسون شوكولاتة',
      'آيس لاتيه',
    ];
    final variant = index % names.length;
    return CafeProduct(
      id: 'product-${index + 1}',
      cafeId: _cafeIds[index ~/ 10],
      name: names[variant],
      nameAr: namesAr[variant],
      description:
          'Crafted to order with carefully sourced ingredients and a balanced finish.',
      descriptionAr: 'يُحضّر حسب الطلب بمكونات مختارة بعناية ونكهة متوازنة.',
      imageAsset: _assets[variant],
      price: 18 + variant * 1.5,
      calories: 80 + variant * 24,
      category: CafeCategory.values[variant % CafeCategory.values.length],
      optionGroups: variant == 8 ? const [] : optionGroups,
      badges: {
        if (index % 4 == 0) ProductBadge.bestseller,
        if (index % 7 == 0) ProductBadge.newArrival,
      },
      available: index % 19 != 0,
    );
  });

  static final reviews = List<CafeReview>.generate(
    12,
    (index) => CafeReview(
      id: 'review-$index',
      author: ['Noor', 'Ali', 'Mariam', 'Omar'][index % 4],
      rating: 5 - index % 3,
      comment: index.isEven
          ? 'Excellent coffee, thoughtful service and a beautiful atmosphere.'
          : 'Consistently good and prepared right on time.',
      createdAt: DateTime(2026, 7, 20).subtract(Duration(days: index)),
      imageAssets: index % 3 == 0
          ? [_assets[index % _assets.length]]
          : const [],
    ),
  );

  Future<void> _wait() async {
    await Future<void>.delayed(delay);
    if (failure != null) throw CafeException(failure!);
  }

  @override
  Future<List<CafeSummary>> fetchCafes() async {
    await _wait();
    return List.unmodifiable(cafes);
  }

  @override
  Future<CafeDetails> fetchCafe(String cafeId) async {
    await _wait();
    final cafe = cafes.where((value) => value.id == cafeId).firstOrNull;
    if (cafe == null) throw const CafeException(CafeFailureType.notFound);
    final menu = products.where((value) => value.cafeId == cafeId).toList();
    return CafeDetails(
      cafe: cafe,
      products: menu,
      reviews: reviews,
      frequentlyOrderedTogether: menu.take(3).toList(),
      recommendedProducts: menu.skip(3).take(4).toList(),
    );
  }

  @override
  Future<CafeProduct> fetchProduct(String productId) async {
    await _wait();
    final product = products
        .where((value) => value.id == productId)
        .firstOrNull;
    if (product == null) throw const CafeException(CafeFailureType.notFound);
    return product;
  }
}
