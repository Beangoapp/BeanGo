import 'package:shared_preferences/shared_preferences.dart';

abstract interface class FavoritesLocalDataSource {
  Future<Set<String>> readCafeIds();
  Future<Set<String>> readProductIds();
  Future<void> writeCafeIds(Set<String> ids);
  Future<void> writeProductIds(Set<String> ids);
}

class SharedPreferencesFavoritesDataSource implements FavoritesLocalDataSource {
  const SharedPreferencesFavoritesDataSource();
  static const _cafesKey = 'favorite_cafe_ids';
  static const _productsKey = 'favorite_product_ids';

  @override
  Future<Set<String>> readCafeIds() async =>
      (await SharedPreferences.getInstance())
          .getStringList(_cafesKey)
          ?.toSet() ??
      {};

  @override
  Future<Set<String>> readProductIds() async =>
      (await SharedPreferences.getInstance())
          .getStringList(_productsKey)
          ?.toSet() ??
      {};

  @override
  Future<void> writeCafeIds(Set<String> ids) async =>
      (await SharedPreferences.getInstance()).setStringList(
        _cafesKey,
        ids.toList()..sort(),
      );

  @override
  Future<void> writeProductIds(Set<String> ids) async =>
      (await SharedPreferences.getInstance()).setStringList(
        _productsKey,
        ids.toList()..sort(),
      );
}

class MemoryFavoritesDataSource implements FavoritesLocalDataSource {
  Set<String> cafes = {};
  Set<String> products = {};
  @override
  Future<Set<String>> readCafeIds() async => Set.of(cafes);
  @override
  Future<Set<String>> readProductIds() async => Set.of(products);
  @override
  Future<void> writeCafeIds(Set<String> ids) async => cafes = Set.of(ids);
  @override
  Future<void> writeProductIds(Set<String> ids) async => products = Set.of(ids);
}
