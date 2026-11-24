import 'package:get/get.dart';

import '../../../data/local/product_local_datasource.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  CartController({this.localDataSource});

  final ProductLocalDataSource? localDataSource;

  static const taxRate = 0.11;
  static const shippingCost = 25000.0;

  final items = <CartItemModel>[].obs;
  final favoriteProducts = <String, ProductModel>{}.obs;

  int get totalItemCount =>
      items.fold(0, (total, item) => total + item.quantity);

  double get subtotal =>
      items.fold(0, (total, item) => total + item.totalPrice);

  double get tax => (subtotal * taxRate).roundToDouble();

  double get shipping => items.isEmpty ? 0 : shippingCost;

  double get total => subtotal + tax + shipping;

  @override
  void onInit() {
    super.onInit();
    if (localDataSource != null) {
      items.assignAll(localDataSource!.getCartItems());
      ever<List<CartItemModel>>(items, (items) {
        localDataSource?.saveCartItems(items);
      });
      favoriteProducts.assignAll({
        for (final product in localDataSource!.getWishlist())
          product.id: product,
      });
    }
  }

  bool isFavorite(String productId) => favoriteProducts.containsKey(productId);

  void addItem(ProductModel product, {required int size, int quantity = 1}) {
    if (quantity <= 0) return;

    final itemId = '${product.id}-$size';
    final index = items.indexWhere((item) => item.id == itemId);
    if (index == -1) {
      items.add(
        CartItemModel(product: product, size: size, quantity: quantity),
      );
      localDataSource?.saveCartItems(items.toList());
      return;
    }

    final existingItem = items[index];
    items[index] = existingItem.copyWith(
      quantity: existingItem.quantity + quantity,
    );
    localDataSource?.saveCartItems(items.toList());
  }

  void updateQuantity(CartItemModel item, int quantity) {
    final index = items.indexWhere((cartItem) => cartItem.id == item.id);
    if (index == -1) return;
    if (quantity <= 0) {
      items.removeAt(index);
      localDataSource?.saveCartItems(items.toList());
      return;
    }
    items[index] = items[index].copyWith(quantity: quantity);
    localDataSource?.saveCartItems(items.toList());
  }

  void removeItem(CartItemModel item) {
    items.removeWhere((cartItem) => cartItem.id == item.id);
    localDataSource?.saveCartItems(items.toList());
  }

  void clearCart() {
    items.clear();
    localDataSource?.clearCartItems();
  }

  void toggleFavorite(ProductModel product) {
    if (favoriteProducts.containsKey(product.id)) {
      favoriteProducts.remove(product.id);
      localDataSource?.removeFromWishlist(product.id);
    } else {
      favoriteProducts[product.id] = product;
      localDataSource?.addToWishlist(product);
    }
  }

  void removeFavorite(String productId) {
    favoriteProducts.remove(productId);
    localDataSource?.removeFromWishlist(productId);
  }

  void clearFavorites() {
    favoriteProducts.clear();
    localDataSource?.clearWishlist();
  }
}
