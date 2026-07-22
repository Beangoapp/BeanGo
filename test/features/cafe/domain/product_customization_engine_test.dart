import 'package:beango/features/cafe/data/repositories/mock_cafe_repository.dart';
import 'package:beango/features/cafe/domain/entities/cafe_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final product = MockCafeRepository.products[1];

  test('required groups must be selected', () {
    final empty = ProductCustomizationEngine.validate(
      product,
      const ProductCustomization(),
    );
    expect(empty.isValid, isFalse);
    expect(empty.invalidGroupIds, containsAll(['size', 'milk']));

    final valid = ProductCustomizationEngine.validate(
      product,
      const ProductCustomization(
        selections: {
          'size': {'large'},
          'milk': {'oat'},
        },
      ),
    );
    expect(valid.isValid, isTrue);
  });

  test('enforces max selections, availability and live price', () {
    const customization = ProductCustomization(
      quantity: 2,
      selections: {
        'size': {'large'},
        'milk': {'oat'},
        'addons': {'vanilla', 'caramel'},
      },
    );
    expect(
      ProductCustomizationEngine.validate(product, customization).isValid,
      isTrue,
    );
    expect(
      ProductCustomizationEngine.total(product, customization),
      (product.price + 5 + 4 + 3 + 3) * 2,
    );
  });
}
