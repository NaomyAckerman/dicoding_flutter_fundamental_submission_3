import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:submission_proyek3/data/db/database_helper.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/provider/database_provider.dart';

void main() {
  group('Crud Favorite Restaurant Database Provider Test', () {
    late DatabaseProvider databaseProvider;
    late Restaurant dummyRestaurant;

    setUpAll(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // arrange
      DatabaseHelper databaseHelper = DatabaseHelper();
      databaseProvider = DatabaseProvider(databaseHelper: databaseHelper);

      await databaseProvider.removeAllRestaurantFavorite();

      dummyRestaurant = Restaurant(
        id: "1",
        name: "Test",
        description: "Test Description",
        pictureId: "123",
        city: "Test City",
        rating: 5.0,
      );
    });

    test(
        'should contain empty favorites when the provider first finishes loading',
        () async {
      // act
      await databaseProvider.getRestaurantFavorites();
      // assert
      List<Restaurant> restaurants = databaseProvider.restaurantFavorites;
      expect(restaurants.length, 0);
    });

    test('must contain 1 favorite when provider is added', () async {
      // act
      await databaseProvider.addRestaurantFavorite(dummyRestaurant);
      await databaseProvider.getRestaurantFavorites();
      // assert
      List<Restaurant> restaurants = databaseProvider.restaurantFavorites;
      expect(restaurants.length, 1);
    });

    test(
        'must contain 1 favorite with the name "Test" when the provider checks whether the favorite is based on the ID',
        () async {
      // act
      await databaseProvider.addRestaurantFavorite(dummyRestaurant);
      bool isFavorite = await databaseProvider.isFavoreted('1');
      // assert
      List<Restaurant> restaurants = databaseProvider.restaurantFavorites;
      expect(isFavorite, true);
      expect(restaurants[0].name, "Test");
    });

    test(
        'should contain 1 favorite when successfully added and empty favorites when successfully deleted',
        () async {
      // act
      await databaseProvider.addRestaurantFavorite(dummyRestaurant);
      await databaseProvider.getRestaurantFavorites();
      List<Restaurant> restaurants = databaseProvider.restaurantFavorites;
      expect(restaurants.length, 1);
      await databaseProvider.removeRestaurantFavorite('1');
      await databaseProvider.getRestaurantFavorites();
      restaurants = databaseProvider.restaurantFavorites;
      expect(restaurants.length, 0);
    });
  });
}
