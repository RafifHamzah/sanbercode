import 'package:get/get.dart';

import '../../cart/bindings/cart_binding.dart';
import '../controllers/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    CartBinding.ensureRegistered();
    Get.lazyPut<DetailController>(
      () => DetailController(),
    );
  }
}
