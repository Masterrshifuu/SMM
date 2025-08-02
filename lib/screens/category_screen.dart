import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smm/models/category.dart';
import 'package:smm/providers/product_provider.dart';
import 'package:smm/widgets/product_card.dart';

class CategoryScreen extends StatelessWidget {
  final Category? category; // null means show all categories

  const CategoryScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = category != null
        ? provider.products.where((p) => p.category == category!.name).toList()
        : provider.products;

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'All Categories'),
      ),
      body: Column(
        children: [
          if (category == null)
            // Grid of categories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: provider.categories.length,
                itemBuilder: (ctx, i) {
                  final category = provider.categories[i];
                  final categoryProducts = provider.products
                      .where((p) => p.category == category.name)
                      .toList();
                  final imageUrl = categoryProducts.isNotEmpty
                      ? categoryProducts.first.imageUrl
                      : '';

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(category: category),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: imageUrl.isNotEmpty
                                ? Image.network(imageUrl, fit: BoxFit.cover)
                                : const Icon(Icons.category, size: 50),
                          ),
                          Container(
                            color: Theme.of(context).colorScheme.surface,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              category.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Products grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (ctx, i) => ProductCard(product: products[i]),
            ),
          ),
        ],
      ),
    );
  }
}