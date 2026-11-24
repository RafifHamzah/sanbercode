import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

abstract interface class ProductLocalDataSource {
  Future<void> init();
  List<ProductModel> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  List<ProductModel> getWishlist();
  Future<void> saveWishlist(List<ProductModel> products);
  Future<void> addToWishlist(ProductModel product);
  Future<void> removeFromWishlist(String productId);
  Future<void> clearWishlist();
  List<CartItemModel> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> clearCartItems();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const productsBoxName = 'products_box';
  static const wishlistBoxName = 'wishlist_box';
  static const cartBoxName = 'cart_box';
  static const _productsKey = 'cached_products';

  late Box<dynamic> _productsBox;
  late Box<dynamic> _wishlistBox;
  late Box<dynamic> _cartBox;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _productsBox = await Hive.openBox<dynamic>(productsBoxName);
    _wishlistBox = await Hive.openBox<dynamic>(wishlistBoxName);
    _cartBox = await Hive.openBox<dynamic>(cartBoxName);
  }

  @override
  List<ProductModel> getCachedProducts() {
    final cached = _productsBox.get(_productsKey);
    if (cached is! List) return const [];
    return cached.whereType<ProductModel>().toList(growable: false);
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _productsBox.put(_productsKey, products);
  }

  @override
  List<ProductModel> getWishlist() =>
      _wishlistBox.values.whereType<ProductModel>().toList(growable: false);

  @override
  Future<void> saveWishlist(List<ProductModel> products) async {
    await _wishlistBox.clear();
    for (final product in products) {
      await _wishlistBox.put(product.id, product);
    }
  }

  @override
  Future<void> addToWishlist(ProductModel product) async {
    await _wishlistBox.put(product.id, product);
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await _wishlistBox.delete(productId);
  }

  @override
  Future<void> clearWishlist() => _wishlistBox.clear();

  @override
  List<CartItemModel> getCartItems() =>
      _cartBox.values.whereType<CartItemModel>().toList(growable: false);

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    await _cartBox.clear();
    for (final item in items) {
      await _cartBox.put(item.id, item);
    }
  }

  @override
  Future<void> clearCartItems() => _cartBox.clear();
}
