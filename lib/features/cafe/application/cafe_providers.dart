import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/favorites_local_data_source.dart';
import '../data/repositories/mock_cafe_repository.dart';
import '../domain/entities/cafe_entities.dart';
import '../domain/repositories/cafe_repository.dart';

final cafeRepositoryProvider = Provider<CafeRepository>(
  (ref) => const MockCafeRepository(),
);
final favoritesDataSourceProvider = Provider<FavoritesLocalDataSource>(
  (ref) => const SharedPreferencesFavoritesDataSource(),
);

final cafeDetailsProvider = FutureProvider.family<CafeDetails, String>(
  (ref, id) => ref.watch(cafeRepositoryProvider).fetchCafe(id),
);
final cafeProductProvider = FutureProvider.family<CafeProduct, String>(
  (ref, id) => ref.watch(cafeRepositoryProvider).fetchProduct(id),
);

class FavoritesState {
  const FavoritesState({this.cafeIds = const {}, this.productIds = const {}});
  final Set<String> cafeIds;
  final Set<String> productIds;
}

final cafeFavoritesProvider =
    AsyncNotifierProvider<CafeFavoritesController, FavoritesState>(
      CafeFavoritesController.new,
    );

class CafeFavoritesController extends AsyncNotifier<FavoritesState> {
  FavoritesLocalDataSource get _storage =>
      ref.read(favoritesDataSourceProvider);
  @override
  Future<FavoritesState> build() async => FavoritesState(
    cafeIds: await _storage.readCafeIds(),
    productIds: await _storage.readProductIds(),
  );

  Future<void> toggleCafe(String id) async {
    final current = state.value ?? const FavoritesState();
    final ids = Set<String>.of(current.cafeIds);
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    state = AsyncData(
      FavoritesState(cafeIds: ids, productIds: current.productIds),
    );
    await _storage.writeCafeIds(ids);
  }

  Future<void> toggleProduct(String id) async {
    final current = state.value ?? const FavoritesState();
    final ids = Set<String>.of(current.productIds);
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    state = AsyncData(
      FavoritesState(cafeIds: current.cafeIds, productIds: ids),
    );
    await _storage.writeProductIds(ids);
  }
}

final productCustomizationProvider = NotifierProvider.autoDispose
    .family<ProductCustomizationController, ProductCustomization, String>(
      ProductCustomizationController.new,
    );

class CafeCartLine {
  const CafeCartLine({required this.product, required this.customization});
  final CafeProduct product;
  final ProductCustomization customization;
}

final cafeCartProvider =
    NotifierProvider<CafeCartController, List<CafeCartLine>>(
      CafeCartController.new,
    );

class CafeCartController extends Notifier<List<CafeCartLine>> {
  @override
  List<CafeCartLine> build() => const [];

  void add(
    CafeProduct product, [
    ProductCustomization customization = const ProductCustomization(),
  ]) {
    state = List.unmodifiable([
      ...state,
      CafeCartLine(product: product, customization: customization),
    ]);
  }
}

class ProductCustomizationController extends Notifier<ProductCustomization> {
  ProductCustomizationController(this.productId);
  final String productId;
  @override
  ProductCustomization build() => const ProductCustomization();

  void toggle(ProductOptionGroup group, String optionId) {
    final selections = {
      for (final entry in state.selections.entries)
        entry.key: Set<String>.of(entry.value),
    };
    final selected = selections.putIfAbsent(group.id, () => <String>{});
    if (group.type == SelectionType.single) {
      selected
        ..clear()
        ..add(optionId);
    } else if (selected.contains(optionId)) {
      selected.remove(optionId);
    } else if (selected.length < group.maxSelections) {
      selected.add(optionId);
    }
    state = state.copyWith(selections: Map.unmodifiable(selections));
  }

  void setQuantity(int quantity) =>
      state = state.copyWith(quantity: quantity.clamp(1, 20));
  void setNotes(String notes) => state = state.copyWith(notes: notes);
  void setSaveAsFavorite(bool value) =>
      state = state.copyWith(saveAsFavorite: value);
}
