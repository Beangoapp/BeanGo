import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthPreferences {
  Future<bool> hasCompletedOnboarding();
  Future<void> completeOnboarding();
}

class SharedPreferencesAuthPreferences implements AuthPreferences {
  const SharedPreferencesAuthPreferences();

  static const _onboardingKey = 'beango.onboarding.completed.v1';

  @override
  Future<bool> hasCompletedOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingKey, true);
  }
}

class MemoryAuthPreferences implements AuthPreferences {
  MemoryAuthPreferences({this.completed = false});

  bool completed;

  @override
  Future<bool> hasCompletedOnboarding() async => completed;

  @override
  Future<void> completeOnboarding() async => completed = true;
}
