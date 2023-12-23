import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/model/restaurant.dart';
import 'package:submission_proyek3/provider/restaurant_provider.dart';
import 'package:submission_proyek3/utils/result_state.dart';
import 'package:submission_proyek3/widgets/exception_widget.dart';
import 'package:submission_proyek3/widgets/input_widget.dart';
import 'package:submission_proyek3/widgets/restaurant_list_widget.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search";

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _keywordController = TextEditingController();

  void _onSearch() {
    Provider.of<RestaurantProvider>(context, listen: false)
        .fetchRestaurantByKeyword(_keywordController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _keywordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Restaurant"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: cPaddingHorizontalSize, vertical: 30),
          child: Column(
            children: [
              InputWidget(
                controller: _keywordController,
                hintText: 'Enter a search term',
                onEditingComplete: _onSearch,
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 30),
              Consumer<RestaurantProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.loading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state.state == ResultState.hasData &&
                      state.searchResult?.restaurants != null) {
                    List<Restaurant> restaurants =
                        state.searchResult!.restaurants;
                    return Column(
                      children: [
                        if (_keywordController.text.isEmpty)
                          const ExceptionWidget(
                              title:
                                  'Please enter keywords to search for restaurants',
                              image: "assets/images/search_data.png")
                        else ...[
                          Text(
                            "${state.searchResult?.founded} restaurants found",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 15),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: cPaddingHorizontalSize),
                            itemBuilder: (context, index) {
                              Restaurant restaurant = restaurants[index];
                              return RestaurantListWidget(
                                restaurant: restaurant,
                                heroTagPrefix: 'search',
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            itemCount: restaurants.length,
                          ),
                        ]
                      ],
                    );
                  } else if (state.state == ResultState.noData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      child: ExceptionWidget(
                        title: state.message,
                        image: "assets/images/no_data.png",
                        width: 200,
                      ),
                    );
                  } else if (state.state == ResultState.error) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      child: ExceptionWidget(
                        title: state.message,
                        image: "assets/images/no_connection.png",
                        width: 200,
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      child: const ExceptionWidget(
                          title:
                              'Please enter keywords to search for restaurants',
                          image: "assets/images/search_data.png"),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
