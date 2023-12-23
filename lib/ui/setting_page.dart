import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/provider/restaurant_preferences_provider.dart';
import 'package:submission_proyek3/provider/scheduling_provider.dart';
import 'package:submission_proyek3/widgets/custome_dialog_widget.dart';
import 'package:submission_proyek3/widgets/platform_widget.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/setting';

  static String title = 'Restaurant Setting';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: primaryColor,
        middle: Text(title),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantPreferencesProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: Text(
                  'Restaurant App Notification',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                subtitle: Text(
                  "Enable notification",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                      value: provider.isDailyNotifActive,
                      onChanged: (value) {
                        if (Platform.isIOS) {
                          customeDialog(
                            context,
                            title: 'Information!',
                            message:
                                'Notifications have been activated, you will receive notifications every 11:00 am',
                          );
                        } else {
                          provider.enableDailyNotif(value);
                          scheduled.scheduledRestaurants(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
