import 'package:beango/features/auth/data/auth_repository.dart';
import 'package:beango/features/auth/domain/auth_failure.dart';
import 'package:beango/features/order_demo/application/demo_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local demo authentication accepts only the documented OTP', () async {
    const repository = LocalDemoAuthRepository();
    await repository.requestOtp(phone: '+97455512345');
    await repository.verifyOtp(phone: '+97455512345', token: '123456');
    await expectLater(
      repository.verifyOtp(phone: '+97455512345', token: '000000'),
      throwsA(isA<InvalidCredentialsFailure>()),
    );
  });

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
