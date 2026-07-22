import 'package:beango/features/cafe/data/datasources/favorites_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persists cafe and product favorites independently', () async {
    final storage = MemoryFavoritesDataSource();

    await storage.writeCafeIds({'flat-white', 'arabica'});
    await storage.writeProductIds({'product-2'});

    expect(await storage.readCafeIds(), {'flat-white', 'arabica'});
    expect(await storage.readProductIds(), {'product-2'});
  });
}
