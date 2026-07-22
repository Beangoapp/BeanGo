import 'package:beango/features/order_demo/application/demo_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('demo cart calculates size, quantity, fees, and reset locally', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(demoCartProvider.notifier);

    controller.setLarge(true);
    controller.increment();
    expect(container.read(demoCartProvider).subtotal, 50);
    expect(container.read(demoCartProvider).total, 52);

    controller.reset();
    expect(container.read(demoCartProvider), isA<DemoCart>());
    expect(container.read(demoCartProvider).quantity, 1);
    expect(container.read(demoCartProvider).isLarge, isFalse);
  });
}
