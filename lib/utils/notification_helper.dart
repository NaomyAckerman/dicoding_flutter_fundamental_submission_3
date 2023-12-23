import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:submission_proyek3/common/navigator.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/api/api_service.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/data/model/restaurant_detail_argument.dart';
import 'package:submission_proyek3/data/model/restaurant_list_result.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        selectNotificationSubject.add(payload);
      }
    });
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantListResult results) async {
    String channelId = "1";
    String channelName = "channel_restaurant";
    String channelDescription = "restaurant notification";

    List<Restaurant> restaurants = results.restaurants;
    int randomIndex = Random().nextInt(restaurants.length);
    Restaurant randomRestaurant = restaurants[randomIndex];
    String titleNotification = "Trending restaurant today";
    String titleRestaurant = randomRestaurant.name;

    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl(
            "${ApiService.largeImageUrl}${randomRestaurant.pictureId}"));

    var bigPictureStyleInformation = BigPictureStyleInformation(
      bigPicture,
      contentTitle: titleNotification,
      htmlFormatContentTitle: true,
      summaryText: titleRestaurant,
      htmlFormatSummaryText: true,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: primaryColor,
      styleInformation: bigPictureStyleInformation,
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleRestaurant,
      platformChannelSpecifics,
      payload: json.encode(randomRestaurant),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        Restaurant restaurant = Restaurant.fromJson(json.decode(payload));
        Navigation.intentWithData(
          route,
          RestaruantDetailArgument(
              restaurant: restaurant,
              pictureTag: "all_${restaurant.pictureId}"),
        );
      },
    );
  }
}
