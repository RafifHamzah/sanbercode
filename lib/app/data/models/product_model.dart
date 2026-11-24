import 'package:hive_ce/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  static const usdToIdrRate = 16000.0;

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final double rating;
  @HiveField(5)
  final int reviewCount;
  @HiveField(6)
  final String image;
  @HiveField(7)
  final String description;
  @HiveField(8)
  final bool isFavorite;

  String get title => name;

  const ProductModel({
    required this.id,
    String? title,
    String? name,
    required this.category,
    required int price,
    required double rating,
    int? reviewCount,
    required this.image,
    String? description,
    bool? isFavorite,
  }) : name = name ?? title ?? '',
       price = price,
       rating = rating,
       reviewCount = reviewCount ?? 0,
       description = description ?? '',
       isFavorite = isFavorite ?? false;

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final title = _stringValue(map['title'] ?? map['name']);
    return ProductModel(
      id: _stringValue(map['id']).isEmpty
          ? title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          : _stringValue(map['id']),
      title: title,
      category: _stringValue(map['category']),
      price: _numberValue(map['price']).round(),
      rating: _numberValue(map['rating']),
      reviewCount: _numberValue(map['reviewCount']).round(),
      image: _stringValue(map['image'] ?? map['imageUrl']),
      description: _stringValue(map['description']),
      isFavorite: map['isFavorite'] == true,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final title = _stringValue(json['title'] ?? json['name']).trim();
    final rawPrice = json['price'];
    if (title.isEmpty || rawPrice == null) {
      throw const FormatException(
        'Data produk tidak memiliki nama atau harga.',
      );
    }

    final parsedPrice = _jsonNumberValue(rawPrice);
    if (parsedPrice == null || !parsedPrice.isFinite || parsedPrice < 0) {
      throw const FormatException('Harga produk tidak valid.');
    }

    final rawId = _stringValue(json['id']);
    return ProductModel(
      id: rawId.isEmpty
          ? title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          : rawId,
      title: title,
      category: _normalizeCategory(_stringValue(json['category'])),
      price: (parsedPrice * usdToIdrRate).round(),
      rating: _numberValue(json['rating']),
      reviewCount: _numberValue(json['reviews'] ?? json['reviewCount']).round(),
      image: _stringValue(
        json['thumbnail'] ?? json['image'] ?? json['imageUrl'],
      ),
      description: _stringValue(json['description']),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'price': price,
    'rating': rating,
    'reviewCount': reviewCount,
    'image': image,
    'description': description,
    'isFavorite': isFavorite,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.toLowerCase().replaceAll(' ', '-'),
    'price': price / usdToIdrRate,
    'rating': rating,
    'reviewCount': reviewCount,
    'description': description,
    'isFavorite': isFavorite,
    'thumbnail': image,
  };

  ProductModel copyWith({
    String? id,
    String? name,
    String? title,
    String? category,
    int? price,
    double? rating,
    int? reviewCount,
    String? image,
    String? description,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? title ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      image: image ?? this.image,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static String _stringValue(Object? value) => value?.toString() ?? '';

  static double _numberValue(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      return double.tryParse(digits) ?? 0;
    }
    return 0;
  }

  static double? _jsonNumberValue(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final match = RegExp(r'-?\d+(?:\.\d+)?').firstMatch(value);
      return double.tryParse(match?.group(0) ?? '');
    }
    return null;
  }

  static String _normalizeCategory(String category) => category
      .split(RegExp(r'[-_\s]+'))
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
