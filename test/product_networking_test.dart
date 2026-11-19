import 'package:dio/dio.dart';
import 'package:e_commerce/app/core/network/dio_exception.dart';
import 'package:e_commerce/app/core/network/result.dart';
import 'package:e_commerce/app/data/models/product_model.dart';
import 'package:e_commerce/app/data/remote/product_remote_datasource.dart';
import 'package:e_commerce/app/data/repository/product_repository.dart';
import 'package:e_commerce/app/modules/cart/controllers/cart_controller.dart';
import 'package:e_commerce/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const product = ProductModel(
    id: 'shoe-1',
    title: 'Test Shoe',
    category: 'Mens Shoes',
    price: 250000,
    rating: 4.5,
    image: 'shoe.png',
  );

  group('ProductModel JSON parsing', () {
    test('converts USD price and normalizes API fields', () {
      final parsed = ProductModel.fromJson({
        'id': 12,
        'title': 'Running Shoe',
        'category': 'mens-shoes',
        'price': 12.5,
        'rating': 4.6,
        'thumbnail': 'thumb.png',
      });

      expect(parsed.id, '12');
      expect(parsed.category, 'Mens Shoes');
      expect(parsed.price, 200000);
      expect(parsed.image, 'thumb.png');
      expect(ProductModel.fromJson(parsed.toJson()).price, parsed.price);
    });

    test('parses a decimal USD string without dropping its decimal point', () {
      final parsed = ProductModel.fromJson({
        'id': 13,
        'title': 'Another Shoe',
        'category': 'mens-shoes',
        'price': '12.99',
        'rating': 4.1,
        'images': ['image.png'],
      });

      expect(parsed.price, 207840);
    });

    test('rejects malformed essential product fields', () {
      expect(
        () => ProductModel.fromJson({
          'id': 14,
          'title': 'Invalid Shoe',
          'category': 'mens-shoes',
          'price': 'unknown',
        }),
        throwsFormatException,
      );
    });
  });

  test(
    'remote datasource requests mens shoes and parses returned products',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              expect(options.path, '/products/category/mens-shoes');
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'products': [
                      {
                        'id': 1,
                        'title': 'Test Shoe',
                        'category': 'mens-shoes',
                        'price': 10,
                        'rating': 4.5,
                        'thumbnail': 'shoe.png',
                      },
                    ],
                  },
                ),
              );
            },
          ),
        );
      final datasource = ProductRemoteDataSourceImpl(dio);

      final products = await datasource.fetchProducts();

      expect(products, hasLength(1));
      expect(products.single.price, 160000);
      expect(products.single.category, 'Mens Shoes');
    },
  );

  test('maps connection failures to a useful network message', () {
    final failure = ErrorHandler.fromDioException(
      DioException(
        requestOptions: RequestOptions(path: '/products'),
        type: DioExceptionType.connectionError,
      ),
    );

    expect(failure.message, contains('Periksa internet'));
  });

  group('ProductRepositoryImpl', () {
    test('wraps remote products in Success', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductRemoteDataSource(products: [product]),
      );

      final result = await repository.fetchProducts();

      expect(result, isA<Success<List<ProductModel>, String>>());
      expect((result as Success<List<ProductModel>, String>).data, [product]);
    });

    test('wraps network failures in Failure', () async {
      final repository = ProductRepositoryImpl(
        _FakeProductRemoteDataSource(error: const NetworkFailure('Offline')),
      );

      final result = await repository.fetchProducts();

      expect(result, isA<Failure<List<ProductModel>, String>>());
      expect((result as Failure<List<ProductModel>, String>).error, 'Offline');
    });
  });

  group('HomeController product loading', () {
    test('loads products from repository', () async {
      final controller = _homeController(
        _FakeProductRepository(result: Success([product])),
      );

      await controller.fetchProducts(showFeedback: false);

      expect(controller.products, [product]);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
    });

    test('shows an error when the first load fails', () async {
      final controller = _homeController(
        _FakeProductRepository(result: const Failure('Offline')),
      );

      await controller.fetchProducts(showFeedback: false);

      expect(controller.products, isEmpty);
      expect(controller.errorMessage.value, 'Offline');
      expect(controller.isLoading.value, isFalse);
    });

    test('preserves existing products when refresh fails', () async {
      final controller = _homeController(
        _FakeProductRepository(result: const Failure('Offline')),
      )..products.addAll([product]);

      await controller.fetchProducts(showFeedback: false);

      expect(controller.products, [product]);
      expect(controller.errorMessage.value, isNull);
    });
  });
}

HomeController _homeController(ProductRepository repository) => HomeController(
  productRepository: repository,
  cartController: CartController(),
);

class _FakeProductRemoteDataSource implements ProductRemoteDataSource {
  final List<ProductModel> products;
  final Object? error;

  const _FakeProductRemoteDataSource({this.products = const [], this.error});

  @override
  Future<List<ProductModel>> fetchProducts() async {
    if (error case final Object error) throw error;
    return products;
  }
}

class _FakeProductRepository implements ProductRepository {
  final Result<List<ProductModel>, String> result;

  const _FakeProductRepository({required this.result});

  @override
  Future<Result<List<ProductModel>, String>> fetchProducts() async => result;
}
