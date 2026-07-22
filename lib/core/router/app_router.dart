import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/domain/entities/auth_state.dart';
import '../../features/authentication/presentation/controllers/authentication_controller.dart';
import '../../features/authentication/presentation/screens/auth_welcome_screen.dart';
import '../../features/authentication/presentation/screens/complete_profile_screen.dart';
import '../../features/authentication/presentation/screens/mobile_login_screen.dart';
import '../../features/authentication/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/otp_verification_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/order_demo/presentation/cart_screen.dart';
import '../../features/order_demo/presentation/checkout_screen.dart';
import '../../features/order_demo/presentation/coffee_details_screen.dart';
import '../../features/order_demo/presentation/order_success_screen.dart';
import '../../features/language/presentation/language_selection_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';
  static const language = '/language';
  static const login = '/login';
  static const verification = '/verification';
  static const authSuccess = '/auth-success';
  static const completeProfile = '/complete-profile';
  static const authWelcome = '/auth-welcome';
  static const coffeeDetails = '/coffee-details';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier();
  ref
    ..onDispose(refresh.dispose)
    ..listen(authenticationControllerProvider, (_, _) => refresh.notify());

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, routerState) {
      final auth = ref.read(authenticationControllerProvider);
      return authRedirectFor(auth, routerState.matchedLocation);
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const MobileLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.verification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.authSuccess,
        redirect: (context, state) => AppRoutes.authWelcome,
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.completeProfile,
        builder: (context, state) => const CompleteProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.authWelcome,
        builder: (context, state) => const AuthWelcomeScreen(),
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
        builder: (context, state) => CoffeeDetailsScreen(
          args: state.extra is CoffeeDetailsArgs
              ? state.extra! as CoffeeDetailsArgs
              : null,
        ),
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

@visibleForTesting
String? authRedirectFor(AuthState auth, String location) {
  if (auth.stage == AuthStage.restoring) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }

  if (auth.stage == AuthStage.profileRequired) {
    return location == AppRoutes.completeProfile
        ? null
        : AppRoutes.completeProfile;
  }

  if (auth.stage == AuthStage.authenticated) {
    const authenticatedEntryRoutes = {
      AppRoutes.splash,
      AppRoutes.onboarding,
      AppRoutes.welcome,
      AppRoutes.language,
      AppRoutes.login,
      AppRoutes.verification,
      AppRoutes.completeProfile,
    };
    return authenticatedEntryRoutes.contains(location) ? AppRoutes.home : null;
  }

  if (!auth.onboardingCompleted) {
    return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
  }

  if (auth.stage == AuthStage.awaitingOtp) {
    return location == AppRoutes.verification || location == AppRoutes.login
        ? null
        : AppRoutes.verification;
  }

  const publicRoutes = {AppRoutes.language, AppRoutes.login, AppRoutes.welcome};
  return publicRoutes.contains(location) ? null : AppRoutes.login;
}

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
