// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get skip => 'Skip';

  @override
  String get continueLabel => 'Continue';

  @override
  String get getStarted => 'Get started';

  @override
  String get welcomeHeadline => 'Your Coffee Knows You';

  @override
  String get welcomeSupportingCopy =>
      'Discover, order, and enjoy coffee tailored to your taste.';

  @override
  String get changeLanguage => 'Language';

  @override
  String get coffeeVisualLabel => 'A premium cup of coffee';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get chooseLanguageBody =>
      'Select the language you want to use across BeanGo.';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'Arabic';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginBody =>
      'Sign in to continue to your coffee, rewards, and favorite cafés.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Enter your email address.';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get noAccount => 'New to BeanGo?';

  @override
  String get createAccount => 'Create account';

  @override
  String get invalidCredentials => 'The email or password is incorrect.';

  @override
  String get loginUnavailable => 'We couldn\'t sign you in. Please try again.';

  @override
  String get enterPhoneTitle => 'Enter your phone number';

  @override
  String get enterPhoneBody =>
      'We\'ll send a one-time code to verify your number.';

  @override
  String get countryCode => 'Code';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneRequired => 'Enter your phone number.';

  @override
  String get phoneInvalid => 'Enter a valid phone number.';

  @override
  String get splashTagline => 'YOUR COFFEE, YOUR MOMENT';

  @override
  String otpDigitLabel(int position) {
    return 'OTP digit $position';
  }

  @override
  String get sendCode => 'Send code';

  @override
  String get phonePrivacy =>
      'We\'ll only use your number to secure your BeanGo account.';

  @override
  String get verifyPhoneTitle => 'Verify your number';

  @override
  String verifyPhoneBody(String phone) {
    return 'Enter the 6-digit code sent to $phone.';
  }

  @override
  String get verificationCode => 'Verification code';

  @override
  String get codeInvalid => 'Enter the valid 6-digit code.';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get verificationSuccessTitle => 'You\'re all set';

  @override
  String get verificationSuccessBody =>
      'Your number is verified. Your coffee journey starts now.';

  @override
  String get orderAgain => 'Order Again';

  @override
  String readyInMinutes(int minutes) {
    return 'Ready in $minutes min';
  }

  @override
  String get onboardingTitleOne => 'Coffee that knows you';

  @override
  String get onboardingBodyOne =>
      'BeanGo learns your taste and brings the right cup closer, wherever you are.';

  @override
  String get onboardingTitleTwo => 'Every café. One elegant experience.';

  @override
  String get onboardingBodyTwo =>
      'Discover standout cafés, order ahead, and collect rewards without the wait.';

  @override
  String get onboardingTitleThree => 'Your perfect cup, one tap away';

  @override
  String get onboardingBodyThree =>
      'Smart recommendations shaped by your routine, mood, and moment.';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get coffeeLover => 'Coffee lover';

  @override
  String get notifications => 'Notifications';

  @override
  String get aiRecommendation => 'Made for your moment';

  @override
  String get recommendationBody =>
      'A thoughtful pick based on your time and coffee routine.';

  @override
  String get why => 'Why?';

  @override
  String get nearbyCafes => 'Nearby cafés';

  @override
  String get nearbyEmpty =>
      'Nearby cafés will appear when location access is enabled.';

  @override
  String get rewards => 'BeanGo Rewards';

  @override
  String get rewardsBody => 'Earn points with every coffee order.';

  @override
  String points(int count) {
    return '$count points';
  }

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get orders => 'Orders';

  @override
  String get profile => 'Profile';

  @override
  String get flatWhite => 'Flat White';

  @override
  String get icedLatte => 'Iced Latte';

  @override
  String get coldBrew => 'Cold Brew';

  @override
  String get espresso => 'Espresso';

  @override
  String get decaf => 'Decaf';

  @override
  String get recommendationReason =>
      'BeanGo selected this coffee using the time of day and your preferences.';

  @override
  String get recommendationsUnavailable =>
      'Recommendations are refreshing. Please try again shortly.';

  @override
  String get demoOtpHint => 'Demo code: 123456';

  @override
  String get coffeeDetails => 'Coffee details';

  @override
  String get signatureFlatWhite => 'Signature Flat White';

  @override
  String get demoCafeName => 'Flat White';

  @override
  String get coffeeDescription =>
      'Velvety steamed milk over a balanced double espresso, crafted for a smooth finish.';

  @override
  String get size => 'Size';

  @override
  String get regular => 'Regular';

  @override
  String get large => 'Large';

  @override
  String get quantity => 'Quantity';

  @override
  String addToCart(String price) {
    return 'Add to cart · $price';
  }

  @override
  String get cart => 'Cart';

  @override
  String get yourOrder => 'Your order';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get serviceFee => 'Service fee';

  @override
  String get total => 'Total';

  @override
  String get continueToCheckout => 'Continue to checkout';

  @override
  String get checkout => 'Checkout';

  @override
  String get pickup => 'Pickup';

  @override
  String get pickupBody => 'Ready at Flat White in about 5 minutes';

  @override
  String get payment => 'Payment';

  @override
  String get paymentBody => 'Demo payment · No charge will be made';

  @override
  String placeOrder(String price) {
    return 'Place order · $price';
  }

  @override
  String get orderConfirmed => 'Order confirmed';

  @override
  String get orderSuccessBody =>
      'Your coffee is being prepared and will be ready in about 5 minutes.';

  @override
  String get backToHome => 'Back to home';

  @override
  String get remove => 'Remove';

  @override
  String get deliveryLocation => 'Delivery location';

  @override
  String get searchCoffee => 'Search coffee or cafés';

  @override
  String get filter => 'Filter';

  @override
  String get promoTitleOne => 'A cooler way to coffee';

  @override
  String get promoBodyOne => 'Iced favorites made for your day.';

  @override
  String get promoTitleTwo => 'Coffee meets pastry';

  @override
  String get promoBodyTwo => 'Pair your cup with something freshly baked.';

  @override
  String get categories => 'Categories';

  @override
  String get hotCoffee => 'Hot coffee';

  @override
  String get coldCoffee => 'Cold coffee';

  @override
  String get pastries => 'Pastries';

  @override
  String get beans => 'Coffee beans';

  @override
  String get recommendedForYou => 'Recommended for you';

  @override
  String get aiPick => 'Picked for you';

  @override
  String get popularToday => 'Popular today';

  @override
  String get spanishLatte => 'Spanish Latte';

  @override
  String get roasteryDistrict => 'Earth Roastery';

  @override
  String get newArrivals => 'New arrivals';

  @override
  String get matchaLatte => 'Matcha Latte';

  @override
  String get pistachioLatte => 'Pistachio Latte';

  @override
  String get saffronLatte => 'Saffron Latte';

  @override
  String get cortado => 'Cortado';

  @override
  String get v60 => 'V60';

  @override
  String get cappuccino => 'Cappuccino';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get orContinueWith => 'or continue with mobile';

  @override
  String get qatarMobileHint => '3, 5, 6 or 7 followed by 7 digits';

  @override
  String get otpExpired => 'This code has expired. Request a new code.';

  @override
  String get networkError => 'Check your connection and try again.';

  @override
  String get completeProfileTitle => 'Tell us about you';

  @override
  String get completeProfileBody =>
      'A few details help us personalize your BeanGo experience.';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameRequired => 'Enter your first and last name.';

  @override
  String get emailOptional => 'Email address (optional)';

  @override
  String get dateOfBirthOptional => 'Date of birth (optional)';

  @override
  String get genderOptional => 'Gender (optional)';

  @override
  String get female => 'Female';

  @override
  String get male => 'Male';

  @override
  String get preferNotToSay => 'Prefer not to say';

  @override
  String get acceptTerms => 'I accept the Terms of Service and Privacy Policy.';

  @override
  String get termsRequired =>
      'Accept the Terms and Privacy Policy to continue.';

  @override
  String get saveAndContinue => 'Save and continue';

  @override
  String get welcomeToBeanGo => 'Welcome to BeanGo';

  @override
  String get welcomeProfileBody =>
      'Your account is ready. Let’s find your next great coffee.';

  @override
  String get startExploring => 'Start exploring';

  @override
  String get logout => 'Log out';

  @override
  String get selectDate => 'Select date';

  @override
  String get changePhone => 'Change phone number';

  @override
  String get changeLocation => 'Change location';

  @override
  String get currentLocation => 'West Bay, Doha';

  @override
  String get searchCafes => 'Search cafés';

  @override
  String get searchDrinks => 'Search drinks';

  @override
  String get searchDesserts => 'Search desserts';

  @override
  String get promoTitleThree => 'A smoother morning';

  @override
  String get promoBodyThree => 'Your Flat White, ready when you are.';

  @override
  String get icedCoffee => 'Iced Coffee';

  @override
  String get espressoCategory => 'Espresso';

  @override
  String get matchaCategory => 'Matcha';

  @override
  String get teaCategory => 'Tea';

  @override
  String get dessertsCategory => 'Desserts';

  @override
  String get bakeryCategory => 'Bakery';

  @override
  String get breakfastCategory => 'Breakfast';

  @override
  String get featuredCafes => 'Featured cafés';

  @override
  String get trendingDrinks => 'Trending drinks';

  @override
  String get recentlyOrdered => 'Recently ordered';

  @override
  String get recommendedForYouTitle => 'Recommended for you';

  @override
  String get viewAll => 'View all';

  @override
  String get openNow => 'Open';

  @override
  String get closedNow => 'Closed';

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String qarPrice(String price) {
    return 'QAR $price';
  }

  @override
  String addToOrder(String item) {
    return 'Add $item to order';
  }

  @override
  String get addedToOrder => 'Added to your order';

  @override
  String favoriteCafe(String cafe) {
    return 'Favorite $cafe';
  }

  @override
  String unfavoriteCafe(String cafe) {
    return 'Remove $cafe from favorites';
  }

  @override
  String get reorder => 'Reorder';

  @override
  String get homeOfflineTitle => 'You\'re offline';

  @override
  String get homeOfflineBody => 'Check your connection and try again.';

  @override
  String get homeErrorTitle => 'We couldn\'t load BeanGo';

  @override
  String get homeErrorBody => 'Something went wrong. Please try again.';

  @override
  String get homeEmptyTitle => 'Coffee is brewing';

  @override
  String get homeEmptyBody => 'No cafés are available in this area yet.';

  @override
  String get retry => 'Retry';

  @override
  String get noSearchResults => 'No matches found';

  @override
  String get noSearchResultsBody => 'Try a different café, drink, or dessert.';

  @override
  String get searchResults => 'Search results';

  @override
  String get americano => 'Americano';

  @override
  String get chocolateCroissant => 'Chocolate Croissant';

  @override
  String get pearlLocation => 'The Pearl, Doha';

  @override
  String get msheirebLocation => 'Msheireb Downtown, Doha';
}
