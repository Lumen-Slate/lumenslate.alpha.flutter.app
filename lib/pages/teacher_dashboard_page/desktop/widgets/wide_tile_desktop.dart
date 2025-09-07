import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WideTile extends StatelessWidget {
  const WideTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.backgroundColor,
    this.onTap,
  });

  final AutoSizeText title;
  final AutoSizeText subTitle;
  final AutoSizeText description;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: 8),
            subTitle,
            const SizedBox(height: 16),
            description,
          ],
        ),
      ),
    );
  }
}

