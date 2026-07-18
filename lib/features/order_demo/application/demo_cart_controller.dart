import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoCart {
  const DemoCart({this.quantity = 1, this.isLarge = false});

  final int quantity;
  final bool isLarge;

  double get unitPrice => isLarge ? 25 : 22;
  double get subtotal => unitPrice * quantity;
  double get serviceFee => 2;
  double get total => subtotal + serviceFee;

  DemoCart copyWith({int? quantity, bool? isLarge}) => DemoCart(
    quantity: quantity ?? this.quantity,
    isLarge: isLarge ?? this.isLarge,
  );
}

final demoCartProvider = NotifierProvider<DemoCartController, DemoCart>(
  DemoCartController.new,
);

class DemoCartController extends Notifier<DemoCart> {
  @override
  DemoCart build() => const DemoCart();

  void setLarge(bool value) => state = state.copyWith(isLarge: value);
  void increment() => state = state.copyWith(quantity: state.quantity + 1);
  void decrement() {
    if (state.quantity > 1) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }

  void reset() => state = const DemoCart();
}
