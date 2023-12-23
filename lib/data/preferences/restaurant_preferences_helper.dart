import 'package:shared_preferences/shared_preferences.dart';

class RestaurantPreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  RestaurantPreferencesHelper({required this.sharedPreferences});

  static const dailyNotif = 'RESTUARANT_DAILY_NOTIFICATION';

  Future<bool> get dailyNotifActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyNotif) ?? false;
  }

  void setDailyNotif(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyNotif, value);
  }
}
