import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class DetailController extends GetxController {
  static const _fallbackProduct = ProductModel(
    id: 'nike-air-jordan-1',
    title: 'Nike Air Jordan 1 Retro High',
    category: 'Basketball',
    price: 2499000,
    rating: 4.9,
    image:
        'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500&q=80',
  );

  late final ProductModel product;
  final quantity = 1.obs;
  final selectedSize = 42.obs;

  CartController get cartController => Get.find<CartController>();
  bool get isFavorite => cartController.isFavorite(product.id);

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is ProductModel) {
      product = arguments;
    } else if (arguments is Map) {
      product = ProductModel.fromMap(Map<String, dynamic>.from(arguments));
    } else {
      product = _fallbackProduct;
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void toggleFavorite() {
    cartController.toggleFavorite(product);
  }

  void addToCart() {
    cartController.addItem(
      product,
      size: selectedSize.value,
      quantity: quantity.value,
    );
  }
}
