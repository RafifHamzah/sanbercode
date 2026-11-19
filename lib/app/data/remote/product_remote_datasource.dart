import 'package:dio/dio.dart';

import '../../core/network/dio_exception.dart';
import '../models/product_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  const ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/products/category/mens-shoes',
      );
      final rawProducts = response.data?['products'];
      if (rawProducts is! List) {
        throw const FormatException(
          'Format katalog dari server tidak valid.',
        );
      }

      return rawProducts.map((item) {
        if (item is! Map) {
          throw const FormatException(
            'Data produk dari server tidak valid.',
          );
        }
        return ProductModel.fromJson(Map<String, dynamic>.from(item));
      }).toList(growable: false);
    } on DioException catch (exception) {
      throw ErrorHandler.fromDioException(exception);
    }
  }
}
