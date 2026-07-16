import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../application/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: .92, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
    _continueToApp();
  }

  Future<void> _continueToApp() async {
    await ref.read(splashControllerProvider).waitUntilReady();
    if (mounted) context.go(AppRoutes.welcome);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.espresso,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _AmbientGlow(),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: const _BrandMark(),
                ),
              ),
            ),
            const Positioned(
              left: 24,
              right: 24,
              bottom: 30,
              child: Text(
                'YOUR COFFEE, YOUR MOMENT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0x99FFF7EC),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'BeanGo',
      image: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.caramel,
              borderRadius: BorderRadius.circular(27),
            ),
            child: const Icon(
              Icons.coffee_rounded,
              size: 42,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'BeanGo',
            style: TextStyle(
              color: AppColors.warmWhite,
              fontSize: 39,
              height: 1,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(.2, -.25),
          radius: .85,
          colors: [Color(0x334F321F), Colors.transparent],
        ),
      ),
    );
  }
}
