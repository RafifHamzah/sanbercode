class ProductModel {
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

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel.fromMap(json);

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'price': price,
    'rating': rating,
    'image': image,
  };

  Map<String, dynamic> toJson() => toMap();

  static String _stringValue(Object? value) => value?.toString() ?? '';

  static double _numberValue(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      return double.tryParse(digits) ?? 0;
    }
    return 0;
  }
}
