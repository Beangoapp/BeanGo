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
}
