import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/onboarding_page_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPageData> _pages(AppLocalizations l10n) => [
    OnboardingPageData(
      title: l10n.onboardingTitleOne,
      body: l10n.onboardingBodyOne,
      artwork: OnboardingArtwork.taste,
      accent: const Color(0xFFD9A060),
    ),
    OnboardingPageData(
      title: l10n.onboardingTitleTwo,
      body: l10n.onboardingBodyTwo,
      artwork: OnboardingArtwork.discover,
      accent: const Color(0xFFB97C55),
    ),
    OnboardingPageData(
      title: l10n.onboardingTitleThree,
      body: l10n.onboardingBodyThree,
      artwork: OnboardingArtwork.moment,
      accent: const Color(0xFFE3B66F),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish() => context.go(AppRoutes.home);

  Future<void> _next(int pageCount) async {
    if (_currentPage == pageCount - 1) {
      _finish();
      return;
    }
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _pages(l10n);
    final isLast = _currentPage == pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            top: -130 + (_currentPage * 18),
            left: Directionality.of(context) == TextDirection.rtl ? -90 : 170,
            child: _GlowOrb(color: pages[_currentPage].accent),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
                  child: Row(
                    children: [
                      const _MiniBrand(),
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: isLast ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: TextButton(
                          onPressed: isLast ? null : _finish,
                          child: Text(l10n.skip),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    itemBuilder: (context, index) => _OnboardingPage(
                      data: pages[index],
                      pageController: _pageController,
                      index: index,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    children: [
                      _PageIndicator(
                        count: pages.length,
                        current: _currentPage,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          onPressed: () => _next(pages.length),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.espresso,
                            foregroundColor: AppColors.warmWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Row(
                              key: ValueKey(isLast),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isLast ? l10n.getStarted : l10n.continueLabel,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? Icons.arrow_back_rounded
                                      : Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.pageController,
    required this.index,
  });

  final OnboardingPageData data;
  final PageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        final page = pageController.hasClients
            ? (pageController.page ?? pageController.initialPage.toDouble())
            : 0.0;
        final delta = (page - index).clamp(-1.0, 1.0);
        final visibility = (1 - delta.abs()).clamp(0.0, 1.0);

        return Opacity(
          opacity: .35 + (.65 * visibility),
          child: Transform.translate(
            offset: Offset(delta * -34, 0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: Hero(
                  tag: 'onboarding-art-$index',
                  child: _ArtworkCard(data: data),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.espresso,
                      fontSize: 34,
                      height: 1.08,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Text(
                      data.body,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xB324160F),
                        fontSize: 16,
                        height: 1.55,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtworkCard extends StatelessWidget {
  const _ArtworkCard({required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .95,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: AppColors.espresso,
          borderRadius: BorderRadius.circular(42),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2524160F),
              blurRadius: 45,
              offset: Offset(0, 22),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomPaint(
          painter: _CoffeeArtworkPainter(
            artwork: data.artwork,
            accent: data.accent,
          ),
        ),
      ),
    );
  }
}

class _CoffeeArtworkPainter extends CustomPainter {
  const _CoffeeArtworkPainter({required this.artwork, required this.accent});

  final OnboardingArtwork artwork;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [accent.withValues(alpha: .38), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * .62));
    canvas.drawCircle(center, size.width * .62, glow);

    switch (artwork) {
      case OnboardingArtwork.taste:
        _paintCup(canvas, size);
      case OnboardingArtwork.discover:
        _paintDiscover(canvas, size);
      case OnboardingArtwork.moment:
        _paintMoment(canvas, size);
    }
  }

  void _paintCup(Canvas canvas, Size size) {
    final cup = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .25,
        size.height * .34,
        size.width * .5,
        size.height * .37,
      ),
      Radius.circular(size.width * .09),
    );
    canvas.drawRRect(cup, Paint()..color = const Color(0xFFFFF8ED));
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .5, size.height * .37),
        width: size.width * .47,
        height: size.height * .12,
      ),
      Paint()..color = const Color(0xFF6B3E28),
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * .67,
        size.height * .42,
        size.width * .24,
        size.height * .24,
      ),
      -1.3,
      2.7,
      false,
      Paint()
        ..color = const Color(0xFFFFF8ED)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .055,
    );
    _steam(canvas, size, .42);
    _steam(canvas, size, .56);
  }

  void _paintDiscover(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0x66FFF8ED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final points = [
      Offset(size.width * .2, size.height * .67),
      Offset(size.width * .42, size.height * .3),
      Offset(size.width * .73, size.height * .56),
    ];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, line);
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(
        points[i],
        i == 1 ? 28 : 18,
        Paint()..color = i == 1 ? accent : const Color(0xFFFFF8ED),
      );
      canvas.drawCircle(
        points[i],
        i == 1 ? 8 : 6,
        Paint()..color = AppColors.espresso,
      );
    }
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      size.width * .38,
      Paint()..color = const Color(0x12FFF8ED),
    );
  }

  void _paintMoment(Canvas canvas, Size size) {
    final ring = Paint()
      ..color = const Color(0xFFFFF8ED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .035;
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .49),
      size.width * .25,
      ring,
    );
    canvas.drawLine(
      Offset(size.width * .5, size.height * .49),
      Offset(size.width * .5, size.height * .36),
      ring..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(size.width * .5, size.height * .49),
      Offset(size.width * .63, size.height * .54),
      ring,
    );
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .49),
      8,
      Paint()..color = accent,
    );
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .49),
      size.width * .35,
      Paint()..color = const Color(0x10FFF8ED),
    );
  }

  void _steam(Canvas canvas, Size size, double x) {
    final path = Path()
      ..moveTo(size.width * x, size.height * .28)
      ..cubicTo(
        size.width * (x - .05),
        size.height * .22,
        size.width * (x + .05),
        size.height * .18,
        size.width * x,
        size.height * .12,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xAAFFF8ED)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CoffeeArtworkPainter oldDelegate) =>
      artwork != oldDelegate.artwork || accent != oldDelegate.accent;
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          width: current == index ? 30 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: current == index
                ? AppColors.espresso
                : const Color(0x3324160F),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

class _MiniBrand extends StatelessWidget {
  const _MiniBrand();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.coffee_rounded, color: AppColors.espresso, size: 21),
        SizedBox(width: 8),
        Text(
          'BeanGo',
          style: TextStyle(
            color: AppColors.espresso,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -.5,
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
