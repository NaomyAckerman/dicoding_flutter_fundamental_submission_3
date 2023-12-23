import 'dart:convert';

import 'package:submission_proyek3/data/model/restaurant_detail.dart';

class RestaurantDetailResult {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResult({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResult.fromRawJson(String str) =>
      RestaurantDetailResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantDetailResult.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailResult(
        error: json["error"],
        message: json["message"],
        restaurant: RestaurantDetail.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}
