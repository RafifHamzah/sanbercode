import 'package:get/get.dart';

import '../../cart/bindings/cart_binding.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    CartBinding.ensureRegistered();
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
