import 'package:get/get.dart';

import '../../cart/bindings/cart_binding.dart';
import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    CartBinding.ensureRegistered();
    Get.lazyPut<WishlistController>(
      () => WishlistController(),
    );
  }
}
