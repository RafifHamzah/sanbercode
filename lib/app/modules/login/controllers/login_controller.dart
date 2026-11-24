import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  static final _emailPattern = RegExp(
    r"^[A-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?"
    r"(?:\.[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?)+$",
    caseSensitive: false,
  );

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final rememberMe = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final authService = Get.find<AuthService>();
    emailController.text =
        Get.find<SharedPreferences>().getString('loggedInEmail') ?? '';
    if (authService.isLoggedIn.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.HOME);
      });
    }
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi.';
    if (!_emailPattern.hasMatch(email)) return 'Format email tidak valid.';
    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Kata sandi wajib diisi.';
    if (password.length < 6) return 'Kata sandi minimal 6 karakter.';
    return null;
  }

  Future<void> submit() async {
    if (isLoading.value || !(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;
    try {
      final authService = Get.find<AuthService>();
      await authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      await authService.setRememberMe(
        rememberMe.value,
        email: emailController.text.trim(),
      );
      Get.snackbar(
        'Berhasil Masuk',
        'Selamat datang kembali di KicksStore!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      final redirect =
          authService.redirectRoute.value ??
          (Get.arguments is Map
              ? (Get.arguments as Map)['redirect']?.toString()
              : null);
      await Get.offAllNamed(
        redirect == Routes.CHECKOUT ? Routes.CHECKOUT : Routes.HOME,
      );
    } on FirebaseAuthException catch (error) {
      final message = Get.find<AuthService>().mapFirebaseAuthError(error);
      Get.snackbar(
        'Login Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
