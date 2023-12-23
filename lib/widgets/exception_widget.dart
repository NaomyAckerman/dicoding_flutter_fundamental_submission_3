import 'package:flutter/material.dart';

class ExceptionWidget extends StatelessWidget {
  final String title;
  final String image;
  final double? width;

  const ExceptionWidget({
    super.key,
    required this.title,
    required this.image,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 160,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
