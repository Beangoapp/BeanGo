// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get skip => 'تخطي';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboardingTitleOne => 'قهوة تعرف ذوقك';

  @override
  String get onboardingBodyOne =>
      'يتعلم BeanGo ذوقك ويقرّب لك الكوب المناسب أينما كنت.';

  @override
  String get onboardingTitleTwo => 'كل المقاهي، بتجربة واحدة راقية';

  @override
  String get onboardingBodyTwo =>
      'اكتشف المقاهي المميزة، اطلب مسبقًا، واجمع مكافآتك بلا انتظار.';

  @override
  String get onboardingTitleThree => 'قهوتك المثالية بلمسة واحدة';

  @override
  String get onboardingBodyThree => 'اقتراحات ذكية تناسب روتينك ومزاجك ولحظتك.';
}
