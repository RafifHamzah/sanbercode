import 'package:get/get.dart';

import '../../cart/bindings/cart_binding.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/local/product_local_datasource.dart';
import '../../../data/remote/product_remote_datasource.dart';
import '../../../data/repository/product_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    CartBinding.ensureRegistered();
    if (!Get.isRegistered<DioClient>()) {
      Get.put<DioClient>(DioClient(), permanent: true);
    }
    if (!Get.isRegistered<ProductRemoteDataSource>()) {
      Get.put<ProductRemoteDataSource>(
        ProductRemoteDataSourceImpl(Get.find<DioClient>().dio),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ProductRepository>()) {
      Get.put<ProductRepository>(
        ProductRepositoryImpl(
          Get.find<ProductRemoteDataSource>(),
          Get.isRegistered<ProductLocalDataSource>()
              ? Get.find<ProductLocalDataSource>()
              : null,
        ),
        permanent: true,
      );
    }
    Get.lazyPut<HomeController>(
      () => HomeController(
        productRepository: Get.find<ProductRepository>(),
        cartController: Get.find<CartController>(),
      ),
    );
  }
}
