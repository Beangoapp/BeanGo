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
  String get splashTagline => 'قهوتك، لحظتك';

  @override
  String otpDigitLabel(int position) {
    return 'الرقم $position من رمز التحقق';
  }

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

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get coffeeLover => 'عاشق القهوة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get aiRecommendation => 'اختيار يناسب لحظتك';

  @override
  String get recommendationBody => 'اقتراح مدروس بناءً على وقتك وروتين قهوتك.';

  @override
  String get why => 'لماذا؟';

  @override
  String get nearbyCafes => 'المقاهي القريبة';

  @override
  String get nearbyEmpty =>
      'ستظهر المقاهي القريبة عند تفعيل الوصول إلى الموقع.';

  @override
  String get rewards => 'مكافآت BeanGo';

  @override
  String get rewardsBody => 'اكسب نقاطًا مع كل طلب قهوة.';

  @override
  String points(int count) {
    return '$count نقطة';
  }

  @override
  String get home => 'الرئيسية';

  @override
  String get explore => 'استكشف';

  @override
  String get orders => 'الطلبات';

  @override
  String get profile => 'حسابي';

  @override
  String get flatWhite => 'فلات وايت';

  @override
  String get icedLatte => 'آيس لاتيه';

  @override
  String get coldBrew => 'كولد برو';

  @override
  String get espresso => 'إسبريسو';

  @override
  String get decaf => 'قهوة منزوعة الكافيين';

  @override
  String get recommendationReason =>
      'اختار BeanGo هذه القهوة بناءً على وقت اليوم وتفضيلاتك.';

  @override
  String get recommendationsUnavailable =>
      'يتم تحديث الاقتراحات. حاول مجددًا بعد قليل.';

  @override
  String get demoOtpHint => 'رمز النسخة التجريبية: 123456';

  @override
  String get coffeeDetails => 'تفاصيل القهوة';

  @override
  String get signatureFlatWhite => 'فلات وايت سيجنتشر';

  @override
  String get demoCafeName => 'Flat White';

  @override
  String get coffeeDescription =>
      'حليب مخملي مبخر فوق جرعتين متوازنتين من الإسبريسو بنهاية ناعمة.';

  @override
  String get size => 'الحجم';

  @override
  String get regular => 'عادي';

  @override
  String get large => 'كبير';

  @override
  String get quantity => 'الكمية';

  @override
  String addToCart(String price) {
    return 'أضف للسلة · $price';
  }

  @override
  String get cart => 'السلة';

  @override
  String get yourOrder => 'طلبك';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get serviceFee => 'رسوم الخدمة';

  @override
  String get total => 'الإجمالي';

  @override
  String get continueToCheckout => 'المتابعة للدفع';

  @override
  String get checkout => 'الدفع';

  @override
  String get pickup => 'الاستلام';

  @override
  String get pickupBody => 'جاهز في Flat White خلال نحو 5 دقائق';

  @override
  String get payment => 'الدفع';

  @override
  String get paymentBody => 'دفع تجريبي · لن يتم خصم أي مبلغ';

  @override
  String placeOrder(String price) {
    return 'تأكيد الطلب · $price';
  }

  @override
  String get orderConfirmed => 'تم تأكيد الطلب';

  @override
  String get orderSuccessBody =>
      'يتم الآن تحضير قهوتك وستكون جاهزة خلال نحو 5 دقائق.';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get remove => 'إزالة';

  @override
  String get deliveryLocation => 'موقع التوصيل';

  @override
  String get searchCoffee => 'ابحث عن قهوة أو مقهى';

  @override
  String get filter => 'تصفية';

  @override
  String get promoTitleOne => 'قهوة أبرد ليوم أجمل';

  @override
  String get promoBodyOne => 'خيارات مثلجة تناسب يومك.';

  @override
  String get promoTitleTwo => 'قهوة مع مخبوزات';

  @override
  String get promoBodyTwo => 'نسّق كوبك مع مخبوزات طازجة.';

  @override
  String get categories => 'التصنيفات';

  @override
  String get hotCoffee => 'قهوة ساخنة';

  @override
  String get coldCoffee => 'قهوة باردة';

  @override
  String get pastries => 'مخبوزات';

  @override
  String get beans => 'حبوب القهوة';

  @override
  String get recommendedForYou => 'مقترح لك';

  @override
  String get aiPick => 'اختيار يناسبك';

  @override
  String get popularToday => 'الأكثر طلبًا اليوم';

  @override
  String get spanishLatte => 'سبانش لاتيه';

  @override
  String get roasteryDistrict => 'Earth Roastery';

  @override
  String get newArrivals => 'وصل حديثًا';

  @override
  String get matchaLatte => 'ماتشا لاتيه';

  @override
  String get pistachioLatte => 'بيستاشيو لاتيه';

  @override
  String get saffronLatte => 'زعفران لاتيه';

  @override
  String get cortado => 'كورتادو';

  @override
  String get v60 => 'V60';

  @override
  String get cappuccino => 'كابتشينو';

  @override
  String get continueWithApple => 'المتابعة عبر Apple';

  @override
  String get continueWithGoogle => 'المتابعة عبر Google';

  @override
  String get orContinueWith => 'أو تابع برقم الجوال';

  @override
  String get qatarMobileHint => 'يبدأ بـ 3 أو 5 أو 6 أو 7 ويتبعه 7 أرقام';

  @override
  String get otpExpired => 'انتهت صلاحية الرمز. اطلب رمزًا جديدًا.';

  @override
  String get networkError => 'تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get completeProfileTitle => 'عرّفنا بنفسك';

  @override
  String get completeProfileBody =>
      'بعض التفاصيل تساعدنا على تخصيص تجربة BeanGo لك.';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNameRequired => 'أدخل الاسم الأول واسم العائلة.';

  @override
  String get emailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get dateOfBirthOptional => 'تاريخ الميلاد (اختياري)';

  @override
  String get genderOptional => 'الجنس (اختياري)';

  @override
  String get female => 'أنثى';

  @override
  String get male => 'ذكر';

  @override
  String get preferNotToSay => 'أفضل عدم الإفصاح';

  @override
  String get acceptTerms => 'أوافق على شروط الخدمة وسياسة الخصوصية.';

  @override
  String get termsRequired => 'وافق على الشروط وسياسة الخصوصية للمتابعة.';

  @override
  String get saveAndContinue => 'حفظ ومتابعة';

  @override
  String get welcomeToBeanGo => 'مرحبًا بك في BeanGo';

  @override
  String get welcomeProfileBody => 'حسابك جاهز. لنكتشف قهوتك القادمة.';

  @override
  String get startExploring => 'ابدأ الاستكشاف';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get changePhone => 'تغيير رقم الجوال';

  @override
  String get changeLocation => 'تغيير الموقع';

  @override
  String get currentLocation => 'الخليج الغربي، الدوحة';

  @override
  String get searchCafes => 'ابحث عن مقهى';

  @override
  String get searchDrinks => 'ابحث عن مشروب';

  @override
  String get searchDesserts => 'ابحث عن حلوى';

  @override
  String get promoTitleThree => 'صباح أكثر سلاسة';

  @override
  String get promoBodyThree => 'فلات وايت جاهز في الوقت المناسب لك.';

  @override
  String get icedCoffee => 'قهوة باردة';

  @override
  String get espressoCategory => 'إسبريسو';

  @override
  String get matchaCategory => 'ماتشا';

  @override
  String get teaCategory => 'شاي';

  @override
  String get dessertsCategory => 'حلويات';

  @override
  String get bakeryCategory => 'مخبوزات';

  @override
  String get breakfastCategory => 'فطور';

  @override
  String get featuredCafes => 'مقاهٍ مميزة';

  @override
  String get trendingDrinks => 'مشروبات رائجة';

  @override
  String get recentlyOrdered => 'طلباتك الأخيرة';

  @override
  String get recommendedForYouTitle => 'مختار لك';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get openNow => 'مفتوح';

  @override
  String get closedNow => 'مغلق';

  @override
  String distanceKm(String distance) {
    return '$distance كم';
  }

  @override
  String qarPrice(String price) {
    return '$price ر.ق';
  }

  @override
  String addToOrder(String item) {
    return 'أضف $item إلى الطلب';
  }

  @override
  String get addedToOrder => 'تمت الإضافة إلى طلبك';

  @override
  String favoriteCafe(String cafe) {
    return 'أضف $cafe إلى المفضلة';
  }

  @override
  String unfavoriteCafe(String cafe) {
    return 'احذف $cafe من المفضلة';
  }

  @override
  String get reorder => 'أعد الطلب';

  @override
  String get homeOfflineTitle => 'لا يوجد اتصال';

  @override
  String get homeOfflineBody => 'تحقق من اتصالك بالإنترنت وحاول مجددًا.';

  @override
  String get homeErrorTitle => 'تعذر تحميل BeanGo';

  @override
  String get homeErrorBody => 'حدث خطأ. حاول مرة أخرى.';

  @override
  String get homeEmptyTitle => 'القهوة قيد التحضير';

  @override
  String get homeEmptyBody => 'لا توجد مقاهٍ متاحة في هذه المنطقة حاليًا.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noSearchResults => 'لا توجد نتائج';

  @override
  String get noSearchResultsBody => 'جرب اسم مقهى أو مشروب أو حلوى مختلفة.';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String get americano => 'أمريكانو';

  @override
  String get chocolateCroissant => 'كرواسون بالشوكولاتة';

  @override
  String get pearlLocation => 'اللؤلؤة، الدوحة';

  @override
  String get msheirebLocation => 'مشيرب قلب الدوحة';
}
