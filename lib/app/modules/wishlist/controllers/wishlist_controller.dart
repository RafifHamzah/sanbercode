import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';

class WishlistController extends GetxController {
  CartController get cartController => Get.find<CartController>();

  List<ProductModel> get favorites =>
      cartController.favoriteProducts.values.toList(growable: false);

  void removeFavorite(ProductModel product) {
    cartController.removeFavorite(product.id);
  }

  void clearFavorites() {
    cartController.clearFavorites();
  }

  void addToCart(ProductModel product) {
    cartController.addItem(product, size: 42);
  }
}
