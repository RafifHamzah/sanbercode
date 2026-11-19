import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce/app/core/theme/app_colors.dart';
import 'package:e_commerce/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'components/product_card.dart';
import 'components/promo_banner.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_run_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                children: const [
                  TextSpan(text: 'Kicks'),
                  TextSpan(
                    text: 'Store',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Wishlist Favorit',
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () => Get.toNamed(Routes.WISHLIST),
          ),

          IconButton(
            tooltip: 'Riwayat Pesanan',
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => Get.toNamed(Routes.ORDERS),
          ),

          IconButton(
            tooltip: 'Ganti Tema',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? AppColors.accent : AppColors.lightTextPrimary,
            ),
            onPressed: () {
              if (Get.isDarkMode) {
                Get.changeThemeMode(ThemeMode.light);
              } else {
                Get.changeThemeMode(ThemeMode.dark);
              }
            },
          ),

          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'Keranjang Belanja',
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => Get.toNamed(Routes.CART),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Obx(() {
                  if (controller.cartCount.value == 0) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${controller.cartCount.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari sneakers favoritmu...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Banner Promosi Toko
            const PromoBanner(),
            const SizedBox(height: 20),

            // Filter Kategori Horizontal
            SizedBox(
              height: 38,
              child: Obx(() {
                final selectedCategory = controller.selectedCategory.value;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    final isSelected = selectedCategory == category;
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => controller.selectCategory(category),
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceCard
                          : Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 20),

            // Judul Bagian Katalog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Katalog Sneakers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Obx(
                  () => Text(
                    '${controller.filteredProducts.length} Produk',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // GridView Produk Katalog
            Obx(() {
              final products = controller.filteredProducts;
              final favoriteIds = controller.favoriteIds.toSet();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final productId = controller.productId(product);
                  return ProductCard(
                    title: product['title'] as String,
                    category: product['category'] as String,
                    price: product['price'] as String,
                    rating: product['rating'] as double,
                    imageUrl: product['image'] as String,
                    isFavorite: favoriteIds.contains(productId),
                    onToggleFavorite: () =>
                        controller.toggleFavorite(productId),
                    onAddToCart: () {
                      controller.addToCart();
                      Get.snackbar(
                        'Ditambahkan',
                        '${product['title']} ditambahkan ke keranjang!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.success,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    onTap: () {
                      Get.toNamed(Routes.DETAIL, arguments: product);
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
