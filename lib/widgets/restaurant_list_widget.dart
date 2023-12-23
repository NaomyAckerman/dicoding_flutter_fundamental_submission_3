import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_proyek3/common/navigator.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/api/api_service.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/data/model/restaurant_detail_argument.dart';
import 'package:submission_proyek3/provider/database_provider.dart';
import 'package:submission_proyek3/ui/restaurant_detail_page.dart';

class RestaurantListWidget extends StatelessWidget {
  const RestaurantListWidget({
    super.key,
    required this.restaurant,
    this.direction = Axis.vertical,
    this.height = 200,
    this.showFavorite = false,
    this.heroTagPrefix,
  });

  final Axis direction;
  final bool showFavorite;
  final double? height;
  final String? heroTagPrefix;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavoreted(restaurant.id),
          builder: (context, snapshot) {
            bool isFavorite = snapshot.data ?? false;
            return direction == Axis.vertical
                ? _verticalList(context, isFavorite, provider)
                : _horizontalList(context, isFavorite, provider);
          },
        );
      },
    );
  }

  Widget _verticalList(
    BuildContext context,
    bool isFavorite,
    DatabaseProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigation.intentWithData(
            RestaurantDetailPage.routeName,
            RestaruantDetailArgument(
              restaurant: restaurant,
              pictureTag: heroTagPrefix != null
                  ? "${restaurant.pictureId}_$heroTagPrefix"
                  : restaurant.pictureId,
            ),
          ),
          child: Hero(
            tag: heroTagPrefix != null
                ? "${restaurant.pictureId}_$heroTagPrefix"
                : restaurant.pictureId,
            child: Stack(
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "${ApiService.mediumImageUrl}${restaurant.pictureId}",
                      ),
                    ),
                  ),
                ),
                if (showFavorite)
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const ShapeDecoration(
                        color: primaryColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        onPressed: () => isFavorite
                            ? provider.removeRestaurantFavorite(restaurant.id)
                            : provider.addRestaurantFavorite(restaurant),
                        isSelected: isFavorite,
                        icon: Icon(
                          Platform.isIOS
                              ? CupertinoIcons.heart
                              : Icons.favorite_border_outlined,
                          color: secondaryColor,
                        ),
                        selectedIcon: Icon(
                          Platform.isIOS
                              ? CupertinoIcons.heart_fill
                              : Icons.favorite,
                          color: secondaryColor,
                        ),
                        highlightColor: Colors.transparent,
                        iconSize: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          restaurant.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 3),
        RichText(
          text: TextSpan(
              style: const TextStyle(
                color: secondaryColor,
              ),
              children: [
                const TextSpan(
                  text: "Location ",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: restaurant.city,
                )
              ]),
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
                  size: 13,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _horizontalList(
    BuildContext context,
    bool isFavorite,
    DatabaseProvider provider,
  ) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigation.intentWithData(
              RestaurantDetailPage.routeName,
              RestaruantDetailArgument(
                restaurant: restaurant,
                pictureTag: heroTagPrefix != null
                    ? "${restaurant.pictureId}_$heroTagPrefix"
                    : restaurant.pictureId,
              ),
            ),
            child: Hero(
              tag: heroTagPrefix != null
                  ? "${restaurant.pictureId}_$heroTagPrefix"
                  : restaurant.pictureId,
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "${ApiService.mediumImageUrl}${restaurant.pictureId}",
                        ),
                      ),
                    ),
                  ),
                  if (showFavorite)
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const ShapeDecoration(
                          color: primaryColor,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          onPressed: () => isFavorite
                              ? provider.removeRestaurantFavorite(restaurant.id)
                              : provider.addRestaurantFavorite(restaurant),
                          isSelected: isFavorite,
                          icon: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.heart
                                : Icons.favorite_border_outlined,
                            color: secondaryColor,
                          ),
                          selectedIcon: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.heart_fill
                                : Icons.favorite,
                            color: secondaryColor,
                          ),
                          highlightColor: Colors.transparent,
                          iconSize: 15,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            restaurant.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadiusDirectional.circular(3),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(
                    Icons.attach_money,
                    size: 13,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadiusDirectional.circular(3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 13,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        restaurant.city,
                        style: const TextStyle(fontSize: 8),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadiusDirectional.circular(3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 13,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(fontSize: 8),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
