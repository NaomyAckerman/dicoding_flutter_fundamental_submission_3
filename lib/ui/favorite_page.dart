import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/api/api_service.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/provider/database_provider.dart';
import 'package:submission_proyek3/utils/result_state.dart';
import 'package:submission_proyek3/widgets/exception_widget.dart';
import 'package:submission_proyek3/widgets/platform_widget.dart';
import 'package:submission_proyek3/widgets/restaurant_list_widget.dart';

class FavoritePage extends StatelessWidget {
  static const String routeName = '/favorite';

  static String title = 'Favorite Restaurant';

  const FavoritePage({super.key});

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
    return RefreshIndicator(
      onRefresh: () => Provider.of<DatabaseProvider>(context, listen: false)
          .getRestaurantFavorites(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Consumer<DatabaseProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<bool>(
                future: ApiService().checkConnection(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (provider.state == ResultState.loading) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (provider.state == ResultState.hasData) {
                        List<Restaurant> restaurants =
                            provider.restaurantFavorites;
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: cPaddingHorizontalSize,
                          ),
                          itemBuilder: (context, index) {
                            Restaurant restaurant = restaurants[index];
                            return SizedBox(
                              width: 250,
                              child: RestaurantListWidget(
                                showFavorite: true,
                                heroTagPrefix: 'favorite',
                                restaurant: restaurant,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemCount: restaurants.length,
                        );
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: ExceptionWidget(
                            title: provider.message,
                            image: "assets/images/no_data.png",
                            width: 200,
                          ),
                        );
                      }
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: const ExceptionWidget(
                          title: "No Connection",
                          image: "assets/images/no_connection.png",
                          width: 200,
                        ),
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
