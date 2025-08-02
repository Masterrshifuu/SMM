import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smm/providers/product_provider.dart';
import 'package:smm/widgets/category_item.dart';
import 'package:smm/widgets/product_card.dart';
import 'package:smm/constants/strings.dart';
import 'package:smm/constants/colors.dart';
import 'package:smm/constants/fonts.dart';
import 'package:smm/utils/datetime.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final deliveryTime = DynamicDeliveryTime.getDeliveryEstimate();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            centerTitle: false,
            title: _buildHeader(context, deliveryTime),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: _buildSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSectionTitle(AppStrings.categories, () {}),
          ),
          SliverToBoxAdapter(
            child: _buildCategoryList(productProvider),
          ),
          SliverToBoxAdapter(
            child: _buildSectionTitle(AppStrings.justForYou, () {}),
          ),
          _buildProductGrid(productProvider),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String deliveryTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', height: 24),
            Text(
              deliveryTime,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                // Navigate to profile screen or handle user tap
              },
            ),
          ],
        ),
        const Text(
          'Pocket 25, Rohini,Subhash Place',
          style: TextStyle(
              fontSize: AppFonts.fontSizeSmall, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.mic_none),
          filled: true,
          fillColor: AppColors.greyLight,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text(AppStrings.viewAll),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryList(ProductProvider provider) {
    return SizedBox(
      height: 140,
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: provider.categories.length,
              itemBuilder: (ctx, i) =>
                  CategoryItem(category: provider.categories[i]),
            ),
    );
  }

  Widget _buildProductGrid(ProductProvider provider) {
    return provider.isLoading
        ? const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()))
        : SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.6,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ProductCard(product: provider.products[index]);
                },
                childCount: provider.products.length,
              ),
            ),
          );
  }
}