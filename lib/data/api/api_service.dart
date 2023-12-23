import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:submission_proyek3/data/model/restaurant_detail_result.dart';
import 'package:submission_proyek3/data/model/restaurant_list_result.dart';
import 'package:submission_proyek3/data/model/restaurant_review_body.dart';
import 'package:submission_proyek3/data/model/restaurant_review_result.dart';
import 'package:submission_proyek3/data/model/restaurant_search_result.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _smallImageUrl =
      'https://restaurant-api.dicoding.dev/images/small/';
  static const String _mediumImageUrl =
      'https://restaurant-api.dicoding.dev/images/medium/';
  static const String _largeImageUrl =
      'https://restaurant-api.dicoding.dev/images/large/';
  static const String _profileUrl = "https://i.pravatar.cc/300?img=";

  static String get largeImageUrl => _largeImageUrl;
  static String get mediumImageUrl => _mediumImageUrl;
  static String get smallImageUrl => _smallImageUrl;
  static String get profileUrl => _profileUrl;

  Future<RestaurantListResult> restaurantList() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return RestaurantListResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResult> restaurantDetail(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearchResult> restaurantSearch(String keyword) async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$keyword"));
    if (response.statusCode == 200) {
      return RestaurantSearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantReviewResult> restaurantAddReview(
      RestaurantReviewBody body) async {
    final response =
        await http.post(Uri.parse("${_baseUrl}review"), body: body.toJson());
    if (response.statusCode == 201) {
      return RestaurantReviewResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add review');
    }
  }

  Future<bool> checkConnection() async {
    try {
      await http.get(Uri.parse("http://google.com"));
      return true;
    } catch (e) {
      throw Exception('Failed to load');
    }
  }
}
