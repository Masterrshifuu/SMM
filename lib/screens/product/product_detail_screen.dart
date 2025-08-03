import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smm/models/product.dart';
import 'package:smm/providers/product_provider.dart';
import 'package:smm/providers/cart_provider.dart';
import 'package:smm/constants/colors.dart';
import 'package:smm/constants/fonts.dart';
import 'package:smm/constants/strings.dart';
import 'package:smm/utils/datetime.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final deliveryTime = DynamicDeliveryTime.getDeliveryEstimate();
    final similarProducts = productProvider.products
        .where((p) => p.category == product.category && p.id != product.id)
        .take(10)
        .toList();
    final featuredProducts = List<Product>.from(productProvider.products)
      ..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productDetails),
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  product.imageUrl,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFonts.fontSizeLarge,
                  fontFamily: AppFonts.poppins,
                ),
              ),
              const SizedBox(height: 8),
              Text('MRP: ₹${product.mrp}',
                  style: const TextStyle(
                      fontSize: AppFonts.fontSizeMedium,
                      fontWeight: FontWeight.bold)),
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(product.description),
              ],
              const SizedBox(height: 8),
              if (deliveryTime.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(deliveryTime, style: const TextStyle(fontSize: AppFonts.fontSizeSmall, color: AppColors.textSecondary)),
                  ],
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text(AppStrings.addToCart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryYellow,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    cart.addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart.'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              if (similarProducts.isNotEmpty) ...[
                const Text('Similar products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.fontSizeMedium)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: similarProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final p = similarProducts[i];
                      return _MiniProductCard(product: p);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const Text('Featured products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.fontSizeMedium)),
              const SizedBox(height: 8),
              SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProducts.length > 10 ? 10 : featuredProducts.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final p = featuredProducts[i];
                    return _MiniProductCard(product: p);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniProductCard extends StatelessWidget {
  final Product product;
  const _MiniProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  product.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text('₹${product.mrp}', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
