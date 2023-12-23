import 'package:flutter/foundation.dart';
import 'package:submission_proyek3/data/db/database_helper.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    getRestaurantFavorites();
  }

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _restaurantFavorites = [];
  List<Restaurant> get restaurantFavorites => _restaurantFavorites;

  Future<void> getRestaurantFavorites() async {
    _restaurantFavorites = await databaseHelper.getFavorites();
    if (_restaurantFavorites.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  Future<void> addRestaurantFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      getRestaurantFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'There is an error in the system, please try again later';
      notifyListeners();
    }
  }

  Future<bool> isFavoreted(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  Future<void> removeRestaurantFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      getRestaurantFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'There is an error in the system, please try again later';
      notifyListeners();
    }
  }

  Future<void> removeAllRestaurantFavorite() async {
    try {
      await databaseHelper.removeAllFavorite();
      getRestaurantFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'There is an error in the system, please try again later';
      notifyListeners();
    }
  }
}
