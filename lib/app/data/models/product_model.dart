class ProductModel {
  static const usdToIdrRate = 16000.0;

  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final String image;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final title = _stringValue(map['title'] ?? map['name']);
    return ProductModel(
      id: _stringValue(map['id']).isEmpty
          ? title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          : _stringValue(map['id']),
      title: title,
      category: _stringValue(map['category']),
      price: _numberValue(map['price']),
      rating: _numberValue(map['rating']),
      image: _stringValue(map['image'] ?? map['imageUrl']),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final title = _stringValue(json['title'] ?? json['name']).trim();
    final rawPrice = json['price'];
    if (title.isEmpty || rawPrice == null) {
      throw const FormatException('Data produk tidak memiliki nama atau harga.');
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
      price: parsedPrice * usdToIdrRate,
      rating: _numberValue(json['rating']),
      image: _stringValue(
        json['thumbnail'] ?? json['image'] ?? json['imageUrl'],
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'price': price,
    'rating': rating,
    'image': image,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.toLowerCase().replaceAll(' ', '-'),
    'price': price / usdToIdrRate,
    'rating': rating,
    'thumbnail': image,
  };

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
