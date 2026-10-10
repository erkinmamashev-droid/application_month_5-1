import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _authenticatedKey = 'authenticated';

  Future<bool> hasCompletedOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<bool> isAuthenticated() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_authenticatedKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingCompleteKey, true);
  }

  Future<void> setAuthenticated(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_authenticatedKey, value);
  }
}
