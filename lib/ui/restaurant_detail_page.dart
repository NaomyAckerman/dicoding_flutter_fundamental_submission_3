import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/api/api_service.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/data/model/restaurant_detail.dart';
import 'package:submission_proyek3/data/model/restaurant_detail_argument.dart';
import 'package:submission_proyek3/provider/database_provider.dart';
import 'package:submission_proyek3/provider/restaurant_provider.dart';
import 'package:submission_proyek3/ui/review_page.dart';
import 'package:submission_proyek3/ui/search_page.dart';
import 'package:submission_proyek3/utils/result_state.dart';
import 'package:submission_proyek3/widgets/exception_widget.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = "/restaurant_detail";

  static String title = 'Restaurant Detail';

  final RestaruantDetailArgument arguments;

  const RestaurantDetailPage({super.key, required this.arguments});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RestaurantProvider>(context, listen: false)
          .fetchDetailRestaurant(widget.arguments.restaurant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> menuTabs = [
      const Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lunch_dining_outlined,
            ),
            SizedBox(width: 7),
            Text('Menus'),
          ],
        ),
      ),
      const Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.comment),
            SizedBox(width: 7),
            Text('Reviews'),
          ],
        ),
      ),
    ];

    return Consumer<RestaurantProvider>(
      builder: (BuildContext context, state, _) {
        if (state.state == ResultState.loading) {
          return _exceptionBuilder(
            context,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.state == ResultState.hasData &&
            state.detailResult?.restaurant != null) {
          RestaurantDetail restaurant = state.detailResult!.restaurant;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: secondaryColor,
              tooltip: 'Add Review',
              onPressed: () => Navigator.pushNamed(
                context,
                ReviewPage.routeName,
                arguments: RestaruantDetailArgument(
                  restaurant: widget.arguments.restaurant,
                  pictureTag: widget.arguments.pictureTag,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              mini: true,
              child: const Icon(
                Icons.add_comment,
                color: Colors.white,
                size: 20,
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, isScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 270,
                    leading: IconButton(
                      highlightColor: Colors.transparent,
                      icon: const Icon(
                        Icons.chevron_left,
                        size: cIconSize,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: [
                      IconButton(
                        highlightColor: Colors.transparent,
                        onPressed: () =>
                            Navigator.pushNamed(context, SearchPage.routeName),
                        icon: const Icon(
                          Icons.search,
                          size: cIconSize,
                        ),
                      )
                    ],
                    foregroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: widget.arguments.pictureTag,
                        child: Image.network(
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey,
                          ),
                          "${ApiService.largeImageUrl}${widget.arguments.restaurant.pictureId}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        RestaurantDetailPage.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      titlePadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 50,
                      ),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: cPaddingHorizontalSize),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Restaurant ${restaurant.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 22,
                                  ),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_pin,
                                            color: primaryColor,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(restaurant.city)
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Wrap(
                                        children: List.generate(
                                            restaurant.categories.length,
                                            (index) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                restaurant
                                                    .categories[index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                              if (index !=
                                                  restaurant.categories.length -
                                                      1)
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 7),
                                                  child: Text("-"),
                                                ),
                                            ],
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            restaurant.rating.toString(),
                                            style: const TextStyle(
                                              color: Colors.amber,
                                            ),
                                          ),
                                          const SizedBox(width: 7),
                                          Row(
                                            children: List.generate(
                                              restaurant.rating.round(),
                                              (index) => const Icon(
                                                Icons.star,
                                                size: 14,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Consumer<DatabaseProvider>(
                                  builder: (context, provider, child) {
                                    return FutureBuilder<bool>(
                                      future:
                                          provider.isFavoreted(restaurant.id),
                                      builder: (context, snapshot) {
                                        bool isFavorite =
                                            snapshot.data ?? false;
                                        return Container(
                                          width: 45,
                                          height: 45,
                                          decoration: const ShapeDecoration(
                                            color: primaryColor,
                                            shape: CircleBorder(),
                                          ),
                                          child: IconButton(
                                            onPressed: () => isFavorite
                                                ? provider
                                                    .removeRestaurantFavorite(
                                                    restaurant.id,
                                                  )
                                                : provider
                                                    .addRestaurantFavorite(
                                                    Restaurant(
                                                      id: restaurant.id,
                                                      name: restaurant.name,
                                                      description: restaurant
                                                          .description,
                                                      pictureId:
                                                          restaurant.pictureId,
                                                      city: restaurant.city,
                                                      rating: restaurant.rating,
                                                    ),
                                                  ),
                                            isSelected: isFavorite,
                                            icon: Icon(
                                              Platform.isIOS
                                                  ? CupertinoIcons.heart
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: secondaryColor,
                                            ),
                                            selectedIcon: Icon(
                                              Platform.isIOS
                                                  ? CupertinoIcons.heart_fill
                                                  : Icons.favorite,
                                              color: secondaryColor,
                                            ),
                                            highlightColor: Colors.transparent,
                                            iconSize: 24,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: cPaddingHorizontalSize),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              restaurant.description,
                              textAlign: TextAlign.justify,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      DefaultTabController(
                        length: menuTabs.length,
                        child: Column(
                          children: <Widget>[
                            TabBar(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: cPaddingHorizontalSize),
                              indicator: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorWeight: 0,
                              automaticIndicatorColorAdjustment: true,
                              splashBorderRadius: BorderRadius.circular(50),
                              labelColor: Colors.white,
                              tabs: menuTabs,
                              dividerColor: Colors.transparent,
                              dividerHeight: 0,
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 310,
                              child: TabBarView(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: cPaddingHorizontalSize),
                                        child: Text(
                                          'Foods',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      SizedBox(
                                        height: 100,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    cPaddingHorizontalSize),
                                            itemBuilder: (context, index) {
                                              int images =
                                                  Random().nextInt(6) + 1;
                                              return Stack(
                                                children: [
                                                  Container(
                                                    width: 170,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          "assets/images/foods/food$images.jpg",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 170,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Color.fromARGB(
                                                              70, 0, 0, 0),
                                                          Colors.black,
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 10,
                                                    child: Text(
                                                      restaurant.menus
                                                          .foods[index].name,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 10),
                                            itemCount:
                                                restaurant.menus.foods.length),
                                      ),
                                      const SizedBox(height: 35),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: cPaddingHorizontalSize),
                                        child: Text(
                                          'Drinks',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      SizedBox(
                                        height: 100,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    cPaddingHorizontalSize),
                                            itemBuilder: (context, index) {
                                              int imagesIndex =
                                                  Random().nextInt(6) + 1;
                                              return Stack(
                                                children: [
                                                  Container(
                                                    width: 170,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          "assets/images/drinks/drink$imagesIndex.jpg",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 170,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Color.fromARGB(
                                                              70, 0, 0, 0),
                                                          Colors.black,
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 10,
                                                    child: Text(
                                                      restaurant.menus
                                                          .drinks[index].name,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 10),
                                            itemCount:
                                                restaurant.menus.drinks.length),
                                      ),
                                    ],
                                  ),
                                  ListView.separated(
                                      itemBuilder: (context, index) => ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal:
                                                        cPaddingHorizontalSize),
                                            leading: CircleAvatar(
                                              backgroundColor: primaryColor,
                                              backgroundImage: NetworkImage(
                                                "${ApiService.profileUrl}$index",
                                              ),
                                            ),
                                            title: Text(
                                              restaurant
                                                  .customerReviews[index].name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              restaurant.customerReviews[index]
                                                  .review,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 0),
                                      itemCount:
                                          restaurant.customerReviews.length),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state.state == ResultState.error) {
          return _exceptionBuilder(
            context,
            body: ExceptionWidget(
              title: state.message,
              image: "assets/images/no_connection.png",
              width: 200,
            ),
          );
        } else {
          return _exceptionBuilder(
            context,
            body: const Center(
              child: Material(
                child: Text(""),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _exceptionBuilder(
    BuildContext context, {
    Widget? body,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RestaurantDetailPage.title),
        titleSpacing: 0,
      ),
      body: body,
    );
  }
}
