import 'package:flutter/material.dart';
import 'package:smm/models/category.dart';
import 'package:smm/constants/fonts.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(category.imageUrl),
          ),
          const SizedBox(height: 5),
          Text(
            category.name,
            style: const TextStyle(fontSize: AppFonts.fontSizeSmall),
          ),
        ],
      ),
    );
  }
}