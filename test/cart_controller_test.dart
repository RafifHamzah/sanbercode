import 'dart:convert';

import 'package:e_commerce/app/data/models/cart_item_model.dart';
import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late CartController controller;
  const product = ProductModel(
    id: 'test-shoe',
    title: 'Test Shoe',
    category: 'Running',
    price: 100000,
    rating: 4.5,
    image: 'https://example.com/shoe.png',
  );

  setUp(() {
    controller = Get.put(CartController());
  });

  tearDown(() {
    Get.reset();
  });

  test('ProductModel converts between Map and typed values', () {
    final parsed = ProductModel.fromMap({
      'title': 'Legacy Shoe',
      'category': 'Casual',
      'price': 'Rp 1.250.000',
      'rating': 4.2,
      'image': 'legacy.png',
    });

    expect(parsed.id, 'legacy-shoe');
    expect(parsed.price, 1250000);
    expect(ProductModel.fromMap(parsed.toMap()).title, parsed.title);
    expect(ProductModel.fromJson(jsonDecode(jsonEncode(parsed))).id, parsed.id);
  });

  test('CartItemModel converts nested product and quantity', () {
    const item = CartItemModel(product: product, size: 42, quantity: 2);

    final parsed = CartItemModel.fromMap(item.toMap());

    expect(parsed.id, 'test-shoe-42');
    expect(parsed.totalPrice, 200000);
    expect(parsed.quantity, 2);
    expect(
      CartItemModel.fromJson(jsonDecode(jsonEncode(item))).totalPrice,
      item.totalPrice,
    );
  });

  test('adding the same product and size merges its quantity', () {
    controller.addItem(product, size: 42);
    controller.addItem(product, size: 42, quantity: 2);
    controller.addItem(product, size: 43);

    expect(controller.items, hasLength(2));
    expect(controller.totalItemCount, 4);
    expect(controller.items.first.quantity, 3);
  });

  test('subtotal, tax, shipping and total update with item quantity', () {
    controller.addItem(product, size: 42, quantity: 2);

    expect(controller.subtotal, 200000);
    expect(controller.tax, 22000);
    expect(controller.shipping, 25000);
    expect(controller.total, 247000);

    controller.updateQuantity(controller.items.single, 1);
    expect(controller.total, 136000);
  });

  test('updating quantity to zero removes the item and shipping', () {
    controller.addItem(product, size: 42);
    controller.updateQuantity(controller.items.single, 0);

    expect(controller.items, isEmpty);
    expect(controller.shipping, 0);
    expect(controller.total, 0);
  });

  test('favorite products are shared and toggleable', () {
    controller.toggleFavorite(product);
    expect(controller.isFavorite(product.id), isTrue);
    expect(controller.favoriteProducts.values.single, product);

    controller.toggleFavorite(product);
    expect(controller.isFavorite(product.id), isFalse);
  });
}
