import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_proyek3/common/styles.dart';
import 'package:submission_proyek3/data/model/restaurant_detail_argument.dart';
import 'package:submission_proyek3/data/model/restaurant_review_body.dart';
import 'package:submission_proyek3/provider/restaurant_provider.dart';
import 'package:submission_proyek3/widgets/input_textarea_widget.dart';
import 'package:submission_proyek3/widgets/input_widget.dart';

class ReviewPage extends StatefulWidget {
  static const routeName = "/review";

  final RestaruantDetailArgument arguments;

  const ReviewPage({
    super.key,
    required this.arguments,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // foregroundColor: Colors.white,
        title: const Text("Add Review Restaurant"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: cPaddingHorizontalSize, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InputWidget(
                  controller: _nameController,
                  hintText: "Type your name",
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                InputTextareaWidget(
                  controller: _reviewController,
                  hintText: "Type your review",
                  textInputAction: TextInputAction.newline,
                  minLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await Provider.of<RestaurantProvider>(context,
                              listen: false)
                          .addRestaurantReview(
                        RestaurantReviewBody(
                            id: widget.arguments.restaurant.id,
                            name: _nameController.text,
                            review: _reviewController.text),
                      )
                          .then((message) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      });
                    }
                  },
                  child: const Text("Send"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
