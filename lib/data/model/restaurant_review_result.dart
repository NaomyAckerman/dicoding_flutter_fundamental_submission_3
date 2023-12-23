import 'dart:convert';

import 'package:submission_proyek3/data/model/customer_review.dart';

class RestaurantReviewResult {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  RestaurantReviewResult({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory RestaurantReviewResult.fromRawJson(String str) =>
      RestaurantReviewResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantReviewResult.fromJson(Map<String, dynamic> json) =>
      RestaurantReviewResult(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}
