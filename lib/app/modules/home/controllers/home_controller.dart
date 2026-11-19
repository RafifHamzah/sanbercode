import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/result.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeController extends GetxController {
  HomeController({
    required this.productRepository,
    required this.cartController,
  });

  final ProductRepository productRepository;
  final CartController cartController;

  final selectedCategory = 'Semua'.obs;
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  final categories = const ['Semua', 'Mens Shoes'];

  List<ProductModel> get filteredProducts {
    final category = selectedCategory.value;
    if (category == 'Semua') return products.toList(growable: false);
    return products
        .where(
          (product) => product.category.toLowerCase() == category.toLowerCase(),
        )
        .toList(growable: false);
  }

  int get cartItemCount => cartController.totalItemCount;

  bool isFavorite(ProductModel product) =>
      cartController.isFavorite(product.id);

  @override
  void onInit() {
    super.onInit();
    unawaited(fetchProducts(showFeedback: false));
  }

  Future<void> fetchProducts({bool showFeedback = true}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await productRepository.fetchProducts();
      switch (result) {
        case Success<List<ProductModel>, String>(data: final remoteProducts):
          products.assignAll(remoteProducts);
          if (showFeedback) {
            Get.snackbar(
              'Katalog Berhasil Diperbarui',
              'Berhasil mengunduh ${remoteProducts.length} sepatu terbaru dari server!',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              backgroundColor: const Color(0xFF10B981),
              colorText: Colors.white,
              icon: const Icon(
                Icons.cloud_done_rounded,
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
          }
        case Failure<List<ProductModel>, String>(error: final error):
          if (products.isEmpty) {
            errorMessage.value = error;
          } else if (showFeedback) {
            Get.snackbar(
              'Mode Offline',
              'Koneksi ke server terputus. Menampilkan ${products.length} produk yang sudah dimuat.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: const Color(0xFFEF4444),
              colorText: Colors.white,
              icon: const Icon(
                Icons.cloud_off_rounded,
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
          }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleFavorite(ProductModel product) {
    cartController.toggleFavorite(product);
  }
}
