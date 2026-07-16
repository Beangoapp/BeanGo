import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashControllerProvider = Provider<SplashController>(
  (ref) => const SplashController(),
);

class SplashController {
  const SplashController();

  Future<void> waitUntilReady() =>
      Future<void>.delayed(const Duration(milliseconds: 1800));
}
