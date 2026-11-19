import 'package:get/get.dart';

import '../../cart/bindings/cart_binding.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    CartBinding.ensureRegistered();
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
