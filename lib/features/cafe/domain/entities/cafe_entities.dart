enum CafeCategory { popular, hotCoffee, icedCoffee, matcha, bakery }

enum ProductBadge { bestseller, newArrival }

enum SelectionType { single, multiple }

class CafeSummary {
  const CafeSummary({
    required this.id,
    required this.name,
    required this.heroImage,
    required this.logoImage,
    required this.rating,
    required this.distanceKm,
    required this.preparationMinutes,
    required this.isOpen,
    required this.openingHours,
  });

  final String id;
  final String name;
  final String heroImage;
  final String logoImage;
  final double rating;
  final double distanceKm;
  final int preparationMinutes;
  final bool isOpen;
  final String openingHours;
}

class CafeProduct {
  const CafeProduct({
    required this.id,
    required this.cafeId,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.imageAsset,
    required this.price,
    required this.calories,
    required this.category,
    required this.optionGroups,
    this.badges = const {},
    this.available = true,
  });

  final String id;
  final String cafeId;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String imageAsset;
  final double price;
  final int calories;
  final CafeCategory category;
  final List<ProductOptionGroup> optionGroups;
  final Set<ProductBadge> badges;
  final bool available;

  String localizedName(bool arabic) => arabic ? nameAr : name;
  String localizedDescription(bool arabic) =>
      arabic ? descriptionAr : description;
}

class ProductOptionGroup {
  const ProductOptionGroup({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.type,
    required this.minSelections,
    required this.maxSelections,
    required this.options,
  }) : assert(minSelections >= 0),
       assert(maxSelections >= minSelections);

  final String id;
  final String name;
  final String nameAr;
  final SelectionType type;
  final int minSelections;
  final int maxSelections;
  final List<ProductOption> options;

  bool get isRequired => minSelections > 0;
  String localizedName(bool arabic) => arabic ? nameAr : name;
}

class ProductOption {
  const ProductOption({
    required this.id,
    required this.name,
    required this.nameAr,
    this.extraPrice = 0,
    this.available = true,
  });

  final String id;
  final String name;
  final String nameAr;
  final double extraPrice;
  final bool available;

  String localizedName(bool arabic) => arabic ? nameAr : name;
}

class ProductCustomization {
  const ProductCustomization({
    this.selections = const {},
    this.notes = '',
    this.quantity = 1,
    this.saveAsFavorite = false,
  });

  final Map<String, Set<String>> selections;
  final String notes;
  final int quantity;
  final bool saveAsFavorite;

  ProductCustomization copyWith({
    Map<String, Set<String>>? selections,
    String? notes,
    int? quantity,
    bool? saveAsFavorite,
  }) => ProductCustomization(
    selections: selections ?? this.selections,
    notes: notes ?? this.notes,
    quantity: quantity ?? this.quantity,
    saveAsFavorite: saveAsFavorite ?? this.saveAsFavorite,
  );
}

class CustomizationValidation {
  const CustomizationValidation({
    required this.isValid,
    this.invalidGroupIds = const [],
  });
  final bool isValid;
  final List<String> invalidGroupIds;
}

abstract final class ProductCustomizationEngine {
  static CustomizationValidation validate(
    CafeProduct product,
    ProductCustomization customization,
  ) {
    final invalid = <String>[];
    for (final group in product.optionGroups) {
      final selected = customization.selections[group.id] ?? const <String>{};
      final validIds = group.options
          .where((option) => option.available)
          .map((option) => option.id)
          .toSet();
      final availableSelections = selected.intersection(validIds);
      if (selected.length != availableSelections.length ||
          availableSelections.length < group.minSelections ||
          availableSelections.length > group.maxSelections) {
        invalid.add(group.id);
      }
    }
    return CustomizationValidation(
      isValid: invalid.isEmpty,
      invalidGroupIds: invalid,
    );
  }

  static double total(CafeProduct product, ProductCustomization customization) {
    var unitPrice = product.price;
    for (final group in product.optionGroups) {
      final selected = customization.selections[group.id] ?? const <String>{};
      for (final option in group.options) {
        if (option.available && selected.contains(option.id)) {
          unitPrice += option.extraPrice;
        }
      }
    }
    return unitPrice * customization.quantity.clamp(1, 99);
  }
}

class CafeReview {
  const CafeReview({
    required this.id,
    required this.author,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.imageAssets = const [],
  });
  final String id;
  final String author;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final List<String> imageAssets;
}

class CafeDetails {
  const CafeDetails({
    required this.cafe,
    required this.products,
    required this.reviews,
    required this.frequentlyOrderedTogether,
    required this.recommendedProducts,
  });
  final CafeSummary cafe;
  final List<CafeProduct> products;
  final List<CafeReview> reviews;
  final List<CafeProduct> frequentlyOrderedTogether;
  final List<CafeProduct> recommendedProducts;
}

enum CafeFailureType { offline, unavailable, notFound }

class CafeException implements Exception {
  const CafeException(this.type);
  final CafeFailureType type;
}
