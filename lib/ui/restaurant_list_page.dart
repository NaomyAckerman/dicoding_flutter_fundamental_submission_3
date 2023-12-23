import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/model/category_menu.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/provider/restaurant_provider.dart';
import 'package:submission_proyek3/ui/search_page.dart';
import 'package:submission_proyek3/utils/result_state.dart';
import 'package:submission_proyek3/widgets/exception_widget.dart';
import 'package:submission_proyek3/widgets/restaurant_list_widget.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = "/restaurant_list";

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  int _currentCategoryMenu = 0;

  @override
  Widget build(BuildContext context) {
    List<CategoryMenu> categoriesMenu = [
      CategoryMenu(title: "All"),
      CategoryMenu(title: "Pizza", icon: Icons.local_pizza),
      CategoryMenu(title: "Burger", icon: Icons.lunch_dining),
      CategoryMenu(title: "Soup", icon: Icons.soup_kitchen),
      CategoryMenu(title: "Kebab", icon: Icons.kebab_dining),
      CategoryMenu(title: "Coffee", icon: Icons.coffee),
    ];

    return RefreshIndicator(
      onRefresh: () => Provider.of<RestaurantProvider>(context, listen: false)
          .fetchAllRestaurant(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.sort,
              size: cIconSize,
            ),
            highlightColor: Colors.transparent,
          ),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, SearchPage.routeName),
              icon: const Icon(
                Icons.search,
                size: cIconSize,
              ),
              highlightColor: Colors.transparent,
            )
          ],
          centerTitle: true,
          title: Text(
            "Restaurant App",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // * HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: cPaddingHorizontalSize),
                    child: Text(
                      "Fast & Delicious \nFood",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // * CATEGORY SLIDER
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: cPaddingHorizontalSize),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InputChip(
                              selected: _currentCategoryMenu == index,
                              selectedColor: primaryColor,
                              checkmarkColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 0.3,
                              ),
                              label: Text(
                                categoriesMenu[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentCategoryMenu = index;
                                });
                              },
                              avatar: categoriesMenu[index].icon != null
                                  ? Icon(categoriesMenu[index].icon)
                                  : null,
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: categoriesMenu.length),
                  ),
                  const SizedBox(height: 30),
                  // * POPULAR RESTAURANT
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: cPaddingHorizontalSize),
                    child: Text(
                      "Popular",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Consumer<RestaurantProvider>(
                      builder: (context, state, _) {
                        if (state.state == ResultState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state.state == ResultState.hasData) {
                          return ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: cPaddingHorizontalSize),
                            itemBuilder: (context, index) {
                              Restaurant restaurant =
                                  state.result.restaurants[index];
                              return RestaurantListWidget(
                                direction: Axis.horizontal,
                                heroTagPrefix: "popular",
                                showFavorite: false,
                                restaurant: restaurant,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 15),
                            itemCount: 7,
                          );
                        } else if (state.state == ResultState.noData) {
                          return ExceptionWidget(
                            title: state.message,
                            image: "assets/images/no_data.png",
                            width: 200,
                          );
                        } else if (state.state == ResultState.error) {
                          return ExceptionWidget(
                            title: state.message,
                            image: "assets/images/no_connection.png",
                            width: 200,
                          );
                        } else {
                          return const Center(
                            child: Material(
                              child: Text(""),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  // * LIST RESTAURANT
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: cPaddingHorizontalSize),
                    child: Text(
                      "All Restaurant",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<RestaurantProvider>(
                    builder: (context, state, _) {
                      if (state.state == ResultState.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.state == ResultState.hasData) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: cPaddingHorizontalSize),
                          itemBuilder: (context, index) {
                            Restaurant restaurant =
                                state.result.restaurants[index];
                            return RestaurantListWidget(
                              showFavorite: true,
                              heroTagPrefix: "all",
                              restaurant: restaurant,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemCount: state.result.count,
                        );
                      } else if (state.state == ResultState.noData) {
                        return ExceptionWidget(
                          title: state.message,
                          image: "assets/images/no_data.png",
                          width: 200,
                        );
                      } else if (state.state == ResultState.error) {
                        return ExceptionWidget(
                          title: state.message,
                          image: "assets/images/no_connection.png",
                          width: 200,
                        );
                      } else {
                        return const Center(
                          child: Material(
                            child: Text(""),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
