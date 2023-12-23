import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:submission_proyek3/common/navigator.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/api/api_service.dart';
import 'package:submission_proyek3/data/db/database_helper.dart';
import 'package:submission_proyek3/data/model/restaurant_detail_argument.dart';
import 'package:submission_proyek3/data/preferences/restaurant_preferences_helper.dart';
import 'package:submission_proyek3/provider/database_provider.dart';
import 'package:submission_proyek3/provider/restaurant_preferences_provider.dart';
import 'package:submission_proyek3/provider/restaurant_provider.dart';
import 'package:submission_proyek3/provider/scheduling_provider.dart';
import 'package:submission_proyek3/ui/favorite_page.dart';
import 'package:submission_proyek3/ui/home_page.dart';
import 'package:submission_proyek3/ui/restaurant_detail_page.dart';
import 'package:submission_proyek3/ui/restaurant_list_page.dart';
import 'package:submission_proyek3/ui/review_page.dart';
import 'package:submission_proyek3/ui/search_page.dart';
import 'package:submission_proyek3/ui/setting_page.dart';
import 'package:submission_proyek3/ui/splash_page.dart';
import 'package:submission_proyek3/utils/background_service.dart';
import 'package:submission_proyek3/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantPreferencesProvider(
            preferencesHelper: RestaurantPreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
      ],
      child: MaterialApp(
        title: 'Submission Proyek 3',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: cColorScheme(context),
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: cTextTheme,
          appBarTheme: cAppBarTheme,
          elevatedButtonTheme: cElevatedButtonTheme,
          textButtonTheme: cTextButtonTheme,
          useMaterial3: true,
        ),
        navigatorKey: navigatorKey,
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName: (context) => const SplashPage(),
          HomePage.routeName: (context) => ChangeNotifierProvider(
                create: (context) => RestaurantProvider(
                  apiService: ApiService(),
                ),
                child: const HomePage(),
              ),
          RestaurantListPage.routeName: (context) => const RestaurantListPage(),
          RestaurantDetailPage.routeName: (context) => ChangeNotifierProvider(
                create: (context) => RestaurantProvider(
                  apiService: ApiService(),
                ),
                child: RestaurantDetailPage(
                  arguments: ModalRoute.of(context)?.settings.arguments
                      as RestaruantDetailArgument,
                ),
              ),
          SearchPage.routeName: (context) => ChangeNotifierProvider(
              create: (context) => RestaurantProvider(
                    apiService: ApiService(),
                  ),
              child: const SearchPage()),
          ReviewPage.routeName: (context) => ChangeNotifierProvider(
                create: (context) => RestaurantProvider(
                  apiService: ApiService(),
                ),
                child: ReviewPage(
                  arguments: ModalRoute.of(context)?.settings.arguments
                      as RestaruantDetailArgument,
                ),
              ),
          SettingsPage.routeName: (context) => const SettingsPage(),
          FavoritePage.routeName: (context) => const FavoritePage()
        },
      ),
    );
  }
}
