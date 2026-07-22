import 'package:beango/features/cafe/data/repositories/mock_cafe_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = MockCafeRepository(delay: Duration.zero);

  test('provides ten cafes and one hundred realistic products', () async {
    final cafes = await repository.fetchCafes();
    expect(cafes, hasLength(10));
    expect(MockCafeRepository.products, hasLength(100));
    for (final cafe in cafes) {
      final details = await repository.fetchCafe(cafe.id);
      expect(details.products, hasLength(10));
      expect(details.reviews, isNotEmpty);
      expect(details.products.first.optionGroups, isNotEmpty);
    }
  });
}
