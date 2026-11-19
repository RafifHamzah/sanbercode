import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class DetailController extends GetxController {
  static const _fallbackProduct = <String, dynamic>{
    'title': 'Nike Air Jordan 1 Retro High',
    'category': 'Basketball',
    'price': 'Rp 2.499.000',
    'rating': 4.9,
    'image':
        'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
  };

  late final Map<String, dynamic> product;
  final quantity = 1.obs;
  final selectedSize = 42.obs;
  final isFavorite = false.obs;

  String get productId => product['title'] as String? ?? '';

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    product = arguments is Map<String, dynamic> ? arguments : _fallbackProduct;

    if (Get.isRegistered<HomeController>()) {
      isFavorite.value = Get.find<HomeController>().isFavorite(productId);
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void toggleFavorite() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.toggleFavorite(productId);
      isFavorite.value = homeController.isFavorite(productId);
      return;
    }
    isFavorite.toggle();
  }

  void addToCart() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().addToCart(quantity.value);
    }
  }
}
