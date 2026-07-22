import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @welcomeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your Coffee Knows You'**
  String get welcomeHeadline;

  /// No description provided for @welcomeSupportingCopy.
  ///
  /// In en, this message translates to:
  /// **'Discover, order, and enjoy coffee tailored to your taste.'**
  String get welcomeSupportingCopy;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get changeLanguage;

  /// No description provided for @coffeeVisualLabel.
  ///
  /// In en, this message translates to:
  /// **'A premium cup of coffee'**
  String get coffeeVisualLabel;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @chooseLanguageBody.
  ///
  /// In en, this message translates to:
  /// **'Select the language you want to use across BeanGo.'**
  String get chooseLanguageBody;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLanguage;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your coffee, rewards, and favorite cafés.'**
  String get loginBody;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'New to BeanGo?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get invalidCredentials;

  /// No description provided for @loginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t sign you in. Please try again.'**
  String get loginUnavailable;

  /// No description provided for @enterPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneTitle;

  /// No description provided for @enterPhoneBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a one-time code to verify your number.'**
  String get enterPhoneBody;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get countryCode;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get phoneInvalid;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @phonePrivacy.
  ///
  /// In en, this message translates to:
  /// **'We\'ll only use your number to secure your BeanGo account.'**
  String get phonePrivacy;

  /// No description provided for @verifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get verifyPhoneTitle;

  /// No description provided for @verifyPhoneBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {phone}.'**
  String verifyPhoneBody(String phone);

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @codeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the valid 6-digit code.'**
  String get codeInvalid;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(int seconds);

  /// No description provided for @verificationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set'**
  String get verificationSuccessTitle;

  /// No description provided for @verificationSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your number is verified. Your coffee journey starts now.'**
  String get verificationSuccessBody;

  /// No description provided for @orderAgain.
  ///
  /// In en, this message translates to:
  /// **'Order Again'**
  String get orderAgain;

  /// No description provided for @readyInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Ready in {minutes} min'**
  String readyInMinutes(int minutes);

  /// No description provided for @onboardingTitleOne.
  ///
  /// In en, this message translates to:
  /// **'Coffee that knows you'**
  String get onboardingTitleOne;

  /// No description provided for @onboardingBodyOne.
  ///
  /// In en, this message translates to:
  /// **'BeanGo learns your taste and brings the right cup closer, wherever you are.'**
  String get onboardingBodyOne;

  /// No description provided for @onboardingTitleTwo.
  ///
  /// In en, this message translates to:
  /// **'Every café. One elegant experience.'**
  String get onboardingTitleTwo;

  /// No description provided for @onboardingBodyTwo.
  ///
  /// In en, this message translates to:
  /// **'Discover standout cafés, order ahead, and collect rewards without the wait.'**
  String get onboardingBodyTwo;

  /// No description provided for @onboardingTitleThree.
  ///
  /// In en, this message translates to:
  /// **'Your perfect cup, one tap away'**
  String get onboardingTitleThree;

  /// No description provided for @onboardingBodyThree.
  ///
  /// In en, this message translates to:
  /// **'Smart recommendations shaped by your routine, mood, and moment.'**
  String get onboardingBodyThree;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @coffeeLover.
  ///
  /// In en, this message translates to:
  /// **'Coffee lover'**
  String get coffeeLover;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @aiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Made for your moment'**
  String get aiRecommendation;

  /// No description provided for @recommendationBody.
  ///
  /// In en, this message translates to:
  /// **'A thoughtful pick based on your time and coffee routine.'**
  String get recommendationBody;

  /// No description provided for @why.
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get why;

  /// No description provided for @nearbyCafes.
  ///
  /// In en, this message translates to:
  /// **'Nearby cafés'**
  String get nearbyCafes;

  /// No description provided for @nearbyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nearby cafés will appear when location access is enabled.'**
  String get nearbyEmpty;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'BeanGo Rewards'**
  String get rewards;

  /// No description provided for @rewardsBody.
  ///
  /// In en, this message translates to:
  /// **'Earn points with every coffee order.'**
  String get rewardsBody;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'{count} points'**
  String points(int count);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @flatWhite.
  ///
  /// In en, this message translates to:
  /// **'Flat White'**
  String get flatWhite;

  /// No description provided for @icedLatte.
  ///
  /// In en, this message translates to:
  /// **'Iced Latte'**
  String get icedLatte;

  /// No description provided for @coldBrew.
  ///
  /// In en, this message translates to:
  /// **'Cold Brew'**
  String get coldBrew;

  /// No description provided for @espresso.
  ///
  /// In en, this message translates to:
  /// **'Espresso'**
  String get espresso;

  /// No description provided for @decaf.
  ///
  /// In en, this message translates to:
  /// **'Decaf'**
  String get decaf;

  /// No description provided for @recommendationReason.
  ///
  /// In en, this message translates to:
  /// **'BeanGo selected this coffee using the time of day and your preferences.'**
  String get recommendationReason;

  /// No description provided for @recommendationsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Recommendations are refreshing. Please try again shortly.'**
  String get recommendationsUnavailable;

  /// No description provided for @demoOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Demo code: 123456'**
  String get demoOtpHint;

  /// No description provided for @coffeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Coffee details'**
  String get coffeeDetails;

  /// No description provided for @signatureFlatWhite.
  ///
  /// In en, this message translates to:
  /// **'Signature Flat White'**
  String get signatureFlatWhite;

  /// No description provided for @demoCafeName.
  ///
  /// In en, this message translates to:
  /// **'Flat White'**
  String get demoCafeName;

  /// No description provided for @coffeeDescription.
  ///
  /// In en, this message translates to:
  /// **'Velvety steamed milk over a balanced double espresso, crafted for a smooth finish.'**
  String get coffeeDescription;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart · {price}'**
  String addToCart(String price);

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @yourOrder.
  ///
  /// In en, this message translates to:
  /// **'Your order'**
  String get yourOrder;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get serviceFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @continueToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Continue to checkout'**
  String get continueToCheckout;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @pickupBody.
  ///
  /// In en, this message translates to:
  /// **'Ready at Flat White in about 5 minutes'**
  String get pickupBody;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentBody.
  ///
  /// In en, this message translates to:
  /// **'Demo payment · No charge will be made'**
  String get paymentBody;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order · {price}'**
  String placeOrder(String price);

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get orderConfirmed;

  /// No description provided for @orderSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your coffee is being prepared and will be ready in about 5 minutes.'**
  String get orderSuccessBody;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @deliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'West Bay, Doha'**
  String get deliveryLocation;

  /// No description provided for @searchCoffee.
  ///
  /// In en, this message translates to:
  /// **'Search coffee or cafés'**
  String get searchCoffee;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @promoTitleOne.
  ///
  /// In en, this message translates to:
  /// **'A cooler way to coffee'**
  String get promoTitleOne;

  /// No description provided for @promoBodyOne.
  ///
  /// In en, this message translates to:
  /// **'Iced favorites made for your day.'**
  String get promoBodyOne;

  /// No description provided for @promoTitleTwo.
  ///
  /// In en, this message translates to:
  /// **'Coffee meets pastry'**
  String get promoTitleTwo;

  /// No description provided for @promoBodyTwo.
  ///
  /// In en, this message translates to:
  /// **'Pair your cup with something freshly baked.'**
  String get promoBodyTwo;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @hotCoffee.
  ///
  /// In en, this message translates to:
  /// **'Hot coffee'**
  String get hotCoffee;

  /// No description provided for @coldCoffee.
  ///
  /// In en, this message translates to:
  /// **'Cold coffee'**
  String get coldCoffee;

  /// No description provided for @pastries.
  ///
  /// In en, this message translates to:
  /// **'Pastries'**
  String get pastries;

  /// No description provided for @beans.
  ///
  /// In en, this message translates to:
  /// **'Coffee beans'**
  String get beans;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @aiPick.
  ///
  /// In en, this message translates to:
  /// **'Picked for you'**
  String get aiPick;

  /// No description provided for @popularToday.
  ///
  /// In en, this message translates to:
  /// **'Popular today'**
  String get popularToday;

  /// No description provided for @spanishLatte.
  ///
  /// In en, this message translates to:
  /// **'Spanish Latte'**
  String get spanishLatte;

  /// No description provided for @roasteryDistrict.
  ///
  /// In en, this message translates to:
  /// **'Earth Roastery'**
  String get roasteryDistrict;

  /// No description provided for @newArrivals.
  ///
  /// In en, this message translates to:
  /// **'New arrivals'**
  String get newArrivals;

  /// No description provided for @matchaLatte.
  ///
  /// In en, this message translates to:
  /// **'Matcha Latte'**
  String get matchaLatte;

  /// No description provided for @pistachioLatte.
  ///
  /// In en, this message translates to:
  /// **'Pistachio Latte'**
  String get pistachioLatte;

  /// No description provided for @saffronLatte.
  ///
  /// In en, this message translates to:
  /// **'Saffron Latte'**
  String get saffronLatte;

  /// No description provided for @cortado.
  ///
  /// In en, this message translates to:
  /// **'Cortado'**
  String get cortado;

  /// No description provided for @v60.
  ///
  /// In en, this message translates to:
  /// **'V60'**
  String get v60;

  /// No description provided for @cappuccino.
  ///
  /// In en, this message translates to:
  /// **'Cappuccino'**
  String get cappuccino;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with mobile'**
  String get orContinueWith;

  /// No description provided for @qatarMobileHint.
  ///
  /// In en, this message translates to:
  /// **'3, 5, 6 or 7 followed by 7 digits'**
  String get qatarMobileHint;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Request a new code.'**
  String get otpExpired;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get networkError;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileBody.
  ///
  /// In en, this message translates to:
  /// **'A few details help us personalize your BeanGo experience.'**
  String get completeProfileBody;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your first and last name.'**
  String get fullNameRequired;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email address (optional)'**
  String get emailOptional;

  /// No description provided for @dateOfBirthOptional.
  ///
  /// In en, this message translates to:
  /// **'Date of birth (optional)'**
  String get dateOfBirthOptional;

  /// No description provided for @genderOptional.
  ///
  /// In en, this message translates to:
  /// **'Gender (optional)'**
  String get genderOptional;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @preferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms of Service and Privacy Policy.'**
  String get acceptTerms;

  /// No description provided for @termsRequired.
  ///
  /// In en, this message translates to:
  /// **'Accept the Terms and Privacy Policy to continue.'**
  String get termsRequired;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get saveAndContinue;

  /// No description provided for @welcomeToBeanGo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BeanGo'**
  String get welcomeToBeanGo;

  /// No description provided for @welcomeProfileBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready. Let’s find your next great coffee.'**
  String get welcomeProfileBody;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get startExploring;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @changePhone.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
