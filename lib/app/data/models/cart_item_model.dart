import 'package:hive_ce/hive.dart';

import 'product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 1)
class CartItemModel {
  @HiveField(0)
  final ProductModel product;
  @HiveField(1)
  final int size;
  @HiveField(2)
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.size,
    required this.quantity,
  });

  String get id => '${product.id}-$size';
  double get totalPrice => product.price.toDouble() * quantity;

  CartItemModel copyWith({int? size, int? quantity}) => CartItemModel(
    product: product,
    size: size ?? this.size,
    quantity: quantity ?? this.quantity,
  );

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    final rawProduct = map['product'];
    final productMap = rawProduct is Map
        ? Map<String, dynamic>.from(rawProduct)
        : map;
    return CartItemModel(
      product: ProductModel.fromMap(productMap),
      size: _intValue(map['size']),
      quantity: _intValue(map['quantity'], fallback: 1),
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      CartItemModel.fromMap(json);

  Map<String, dynamic> toMap() => {
    'product': product.toMap(),
    'size': size,
    'quantity': quantity,
  };

  Map<String, dynamic> toJson() => toMap();

  static int _intValue(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
