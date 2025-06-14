import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class WideTile extends StatelessWidget {
  const WideTile(
      {super.key,
        required this.title,
        required this.subTitle,
        required this.description,
        required this.backgroundColor});

  final AutoSizeText title;
  final AutoSizeText subTitle;
  final AutoSizeText description;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 350,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(42.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(
              height: 10,
            ),
            subTitle,
            const SizedBox(
              height: 24,
            ),
            description,
          ],
        ),
      ),
    );
  }
}
