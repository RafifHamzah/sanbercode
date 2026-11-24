import 'package:get/get.dart';

import '../../../data/local/product_local_datasource.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  static void ensureRegistered() {
    if (!Get.isRegistered<CartController>()) {
      final localDataSource = Get.isRegistered<ProductLocalDataSource>()
          ? Get.find<ProductLocalDataSource>()
          : null;
      Get.put<CartController>(
        CartController(localDataSource: localDataSource),
        permanent: true,
      );
    }
  }

  @override
  void dependencies() {
    ensureRegistered();
  }
}
