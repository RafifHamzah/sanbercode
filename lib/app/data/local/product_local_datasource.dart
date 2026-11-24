import 'package:hive_ce_flutter/hive_flutter.dart';

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
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const productsBoxName = 'products_box';
  static const wishlistBoxName = 'wishlist_box';
  static const _productsKey = 'cached_products';

  late Box<dynamic> _productsBox;
  late Box<dynamic> _wishlistBox;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _productsBox = await Hive.openBox<dynamic>(productsBoxName);
    _wishlistBox = await Hive.openBox<dynamic>(wishlistBoxName);
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
}
