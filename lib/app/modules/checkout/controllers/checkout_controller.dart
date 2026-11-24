import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../cart/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  static const discountAmount = 25000.0;

  final cartController = Get.find<CartController>();
  final couponController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final appliedCouponCode = RxnString();

  double get discount => appliedCouponCode.value == null ? 0 : discountAmount;

  double get total =>
      (cartController.total - discount).clamp(0, double.infinity);
  bool applyCoupon() {
    final code = couponController.text.trim().toUpperCase();
    if (!{'SNEKISA', 'SNKISA', 'KICKS25'}.contains(code)) {
      appliedCouponCode.value = null;
      Get.snackbar(
        'Kupon Tidak Valid',
        'Kode kupon promo tidak ditemukan atau telah kedaluwarsa.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }

    appliedCouponCode.value = code;
    Get.snackbar(
      'Kupon Berhasil Dipasang 🎉',
      'Diskon Rp 25.000 telah diterapkan untuk pesananmu.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
    return true;
  }

  bool validateShippingForm() => formKey.currentState?.validate() ?? false;

  @override
  void onClose() {
    couponController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
