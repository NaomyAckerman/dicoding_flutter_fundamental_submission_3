import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submission_proyek3/data/api/api_service.dart';
import 'package:submission_proyek3/data/model/restaurant_detail_result.dart';
import 'package:submission_proyek3/data/model/restaurant_list_result.dart';
import 'package:submission_proyek3/data/model/restaurant_review_body.dart';
import 'package:submission_proyek3/data/model/restaurant_search_result.dart';
import 'package:submission_proyek3/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  late RestaurantListResult _restaurantListResult;
  RestaurantDetailResult? _restaurantDetailResult;
  RestaurantSearchResult? _restaurantSearchResult;
  ResultState _state = ResultState.loading;
  String _message = '';

  RestaurantProvider({required this.apiService}) {
    fetchAllRestaurant();
  }

  RestaurantListResult get result => _restaurantListResult;

  RestaurantDetailResult? get detailResult => _restaurantDetailResult;

  RestaurantSearchResult? get searchResult => _restaurantSearchResult;

  ResultState get state => _state;

  String get message => _message;

  Future<void> fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.restaurantList();
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _message = result.message;
        _restaurantListResult = result;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'No Connection';
      notifyListeners();
    }
  }

  Future<void> fetchDetailRestaurant(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.restaurantDetail(id);
      if (result.error) {
        _state = ResultState.noData;
        _message = 'Data Not Found';
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _message = result.message;
        _restaurantDetailResult = result;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'No Connection';
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantByKeyword(String keyword) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.restaurantSearch(keyword);
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'Restaurant Not Found';
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _message = "Data Founded ${result.founded}";
        _restaurantSearchResult = result;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'No Connection';
      notifyListeners();
    }
  }

  Future<String> addRestaurantReview(RestaurantReviewBody body) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.restaurantAddReview(body);
      if (result.error) {
        _state = ResultState.noData;
        _message = 'Fail Add Review';
        notifyListeners();
      } else {
        _state = ResultState.hasData;
        _message = "Successfully Added a Review";
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'No Connection';
      notifyListeners();
    }
    return _message;
  }
}
