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
  String get welcomeHeadline => 'قهوتك تعرفك';

  @override
  String get welcomeSupportingCopy => 'اكتشف واطلب واستمتع بقهوة تناسب ذوقك.';

  @override
  String get changeLanguage => 'اللغة';

  @override
  String get coffeeVisualLabel => 'كوب قهوة فاخر';

  @override
  String get chooseLanguage => 'اختر لغتك';

  @override
  String get chooseLanguageBody => 'اختر اللغة التي تفضل استخدامها في BeanGo.';

  @override
  String get englishLanguage => 'الإنجليزية';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get loginBody =>
      'سجّل الدخول للوصول إلى قهوتك ومكافآتك ومقاهيك المفضلة.';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get emailRequired => 'أدخل بريدك الإلكتروني.';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا.';

  @override
  String get passwordRequired => 'أدخل كلمة المرور.';

  @override
  String get passwordTooShort => 'يجب ألا تقل كلمة المرور عن 8 أحرف.';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get noAccount => 'جديد في BeanGo؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get invalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get loginUnavailable => 'تعذر تسجيل دخولك. حاول مرة أخرى.';

  @override
  String get enterPhoneTitle => 'أدخل رقم هاتفك';

  @override
  String get enterPhoneBody => 'سنرسل رمزًا لمرة واحدة للتحقق من رقمك.';

  @override
  String get countryCode => 'الرمز';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneRequired => 'أدخل رقم هاتفك.';

  @override
  String get phoneInvalid => 'أدخل رقم هاتف صحيحًا.';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get phonePrivacy => 'سنستخدم رقمك فقط لحماية حسابك في BeanGo.';

  @override
  String get verifyPhoneTitle => 'تحقق من رقمك';

  @override
  String verifyPhoneBody(String phone) {
    return 'أدخل الرمز المكوّن من 6 أرقام المرسل إلى $phone.';
  }

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get codeInvalid => 'أدخل رمز التحقق الصحيح المكوّن من 6 أرقام.';

  @override
  String get verifyCode => 'تحقق من الرمز';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendCodeIn(int seconds) {
    return 'إعادة الإرسال خلال $secondsث';
  }

  @override
  String get verificationSuccessTitle => 'تم بنجاح';

  @override
  String get verificationSuccessBody =>
      'تم التحقق من رقمك. رحلتك مع القهوة تبدأ الآن.';

  @override
  String get orderAgain => 'اطلب مرة أخرى';

  @override
  String readyInMinutes(int minutes) {
    return 'جاهز خلال $minutes دقائق';
  }

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
