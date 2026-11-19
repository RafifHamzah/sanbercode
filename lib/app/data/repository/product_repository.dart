import 'package:flutter/foundation.dart';

import '../../core/network/dio_exception.dart';
import '../../core/network/result.dart';
import '../models/product_model.dart';
import '../remote/product_remote_datasource.dart';

abstract interface class ProductRepository {
  Future<Result<List<ProductModel>, String>> fetchProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  const ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async {
    try {
      final products = await remoteDataSource.fetchProducts();
      return Success<List<ProductModel>, String>(products);
    } on NetworkFailure catch (failure) {
      return Failure<List<ProductModel>, String>(failure.message);
    } on FormatException catch (exception) {
      return Failure<List<ProductModel>, String>(exception.message);
    } catch (error, stackTrace) {
      debugPrint('Unexpected error while fetching products: $error');
      debugPrintStack(stackTrace: stackTrace);
      return const Failure<List<ProductModel>, String>(
        'Terjadi kesalahan saat memuat katalog.',
      );
    }
  }
}
