import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/ui/favorite_page.dart';
import 'package:submission_proyek3/ui/restaurant_detail_page.dart';
import 'package:submission_proyek3/ui/restaurant_list_page.dart';
import 'package:submission_proyek3/ui/setting_page.dart';
import 'package:submission_proyek3/utils/notification_helper.dart';
import 'package:submission_proyek3/widgets/platform_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    const RestaurantListPage(),
    const FavoritePage(),
    const SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      activeIcon: Icon(
        Platform.isIOS ? CupertinoIcons.house_fill : Icons.house,
      ),
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.house : Icons.house_outlined,
      ),
      label: "Home",
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(
        Platform.isIOS ? CupertinoIcons.heart_solid : Icons.favorite,
      ),
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.heart : Icons.favorite_border_outlined,
      ),
      label: "Favorite",
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(
        Platform.isIOS ? CupertinoIcons.settings_solid : Icons.settings,
      ),
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.settings : Icons.settings_outlined,
      ),
      label: "Setting",
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(
      RestaurantDetailPage.routeName,
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomNavBarItems,
        activeColor: secondaryColor,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }
}
