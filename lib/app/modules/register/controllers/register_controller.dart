import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../login/controllers/login_controller.dart';

class RegisterController extends GetxController {
  static final _emailPattern = RegExp(
    r"^[A-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?"
    r"(?:\.[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?)+$",
    caseSensitive: false,
  );

  final formKey = GlobalKey<FormState>();
  final confirmPasswordFieldKey = GlobalKey<FormFieldState<String>>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Nama lengkap wajib diisi.';
    if (name.length < 2) return 'Nama minimal 2 karakter.';
    return null;
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

  String? validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi wajib diisi.';
    }
    if (value != passwordController.text) {
      return 'Konfirmasi kata sandi belum cocok.';
    }
    return null;
  }

  void validateConfirmationOnPasswordChange() {
    confirmPasswordFieldKey.currentState?.validate();
  }

  Future<void> submit() async {
    if (isLoading.value || !(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;
    try {
      final authService = Get.find<AuthService>();
      final registeredEmail = emailController.text.trim();
      await authService.register(
        name: nameController.text.trim(),
        email: registeredEmail,
        password: passwordController.text,
      );
      final returnRoute = authService.redirectRoute.value;
      if (returnRoute != null && returnRoute.isNotEmpty) {
        Get.offAllNamed(returnRoute);
      } else {
        await authService.signOut(preserveEmail: true);
        if (Get.isRegistered<LoginController>()) {
          Get.find<LoginController>().emailController.text = registeredEmail;
        }
        Get.back();
      }
      Get.snackbar(
        'Pendaftaran Berhasil 🎉',
        returnRoute == null
            ? 'Akunmu berhasil didaftarkan. Silakan masuk menggunakan email dan password baru.'
            : 'Akunmu berhasil didaftarkan. Checkout dapat dilanjutkan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } on FirebaseAuthException catch (error) {
      final message = Get.find<AuthService>().mapFirebaseAuthError(error);
      Get.snackbar(
        'Pendaftaran Gagal',
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
