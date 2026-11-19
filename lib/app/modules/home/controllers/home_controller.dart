import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeController extends GetxController {
  final cartController = Get.find<CartController>();
  final selectedCategory = 'Semua'.obs;

  final categories = const [
    'Semua',
    'Lifestyle',
    'Running',
    'Basketball',
    'Skate',
    'Casual',
  ];

  final products = const <ProductModel>[
    ProductModel(
      id: 'nike-air-jordan-1',
      title: 'Nike Air Jordan 1 Retro High',
      category: 'Basketball',
      price: 2499000,
      rating: 4.9,
      image:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
    ),
    ProductModel(
      id: 'nike-air-force-1',
      title: 'Nike Air Force 1 07 Triple White',
      category: 'Lifestyle',
      price: 1549000,
      rating: 4.8,
      image:
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500&q=80',
    ),
    ProductModel(
      id: 'adidas-ultraboost-light',
      title: 'Adidas Ultraboost Light Running',
      category: 'Running',
      price: 2899000,
      rating: 4.7,
      image:
          'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=500&q=80',
    ),
    ProductModel(
      id: 'puma-suede-classic',
      title: 'Puma Suede Classic XXI Black',
      category: 'Casual',
      price: 1099000,
      rating: 4.6,
      image:
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500&q=80',
    ),
    ProductModel(
      id: 'new-balance-574',
      title: 'New Balance 574 Core Grey',
      category: 'Lifestyle',
      price: 1499000,
      rating: 4.8,
      image:
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=500&q=80',
    ),
    ProductModel(
      id: 'vans-old-skool',
      title: 'Vans Old Skool Classic Skate',
      category: 'Skate',
      price: 999000,
      rating: 4.7,
      image:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500&q=80',
    ),
  ];

  List<ProductModel> get filteredProducts {
    final category = selectedCategory.value;
    if (category == 'Semua') return products;
    return products.where((product) => product.category == category).toList();
  }

  int get cartItemCount => cartController.totalItemCount;

  bool isFavorite(ProductModel product) =>
      cartController.isFavorite(product.id);

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleFavorite(ProductModel product) {
    cartController.toggleFavorite(product);
  }
}
