import 'package:flutter/material.dart';
import 'package:submission_proyek3/data/preferences/restaurant_preferences_helper.dart';

class RestaurantPreferencesProvider extends ChangeNotifier {
  RestaurantPreferencesHelper preferencesHelper;

  RestaurantPreferencesProvider({required this.preferencesHelper}) {
    getDailyNotif();
  }

  bool _isDailyNotifActive = false;
  bool get isDailyNotifActive => _isDailyNotifActive;

  Future<void> getDailyNotif() async {
    _isDailyNotifActive = await preferencesHelper.dailyNotifActive;
    notifyListeners();
  }

  void enableDailyNotif(bool value) {
    preferencesHelper.setDailyNotif(value);
    getDailyNotif();
  }
}
