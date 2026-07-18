import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/order_demo/presentation/cart_screen.dart';
import '../../features/order_demo/presentation/checkout_screen.dart';
import '../../features/order_demo/presentation/coffee_details_screen.dart';
import '../../features/order_demo/presentation/order_success_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/auth_success_screen.dart';
import '../../features/auth/presentation/verification_screen.dart';
import '../../features/language/presentation/language_selection_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const welcome = '/welcome';
  static const language = '/language';
  static const login = '/login';
  static const verification = '/verification';
  static const authSuccess = '/auth-success';
  static const coffeeDetails = '/coffee-details';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.verification,
        builder: (context, state) {
          final phone = state.extra;
          if (phone is! String || phone.isEmpty) return const LoginScreen();
          return VerificationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.authSuccess,
        builder: (context, state) => const AuthSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.coffeeDetails,
        builder: (context, state) => const CoffeeDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        builder: (context, state) => const OrderSuccessScreen(),
      ),
    ],
  );
});
