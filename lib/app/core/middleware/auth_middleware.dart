import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Get.isRegistered<AuthService>() &&
        Get.find<AuthService>().isLoggedIn.value) {
      return null;
    }

    if (Get.isRegistered<AuthService>()) {
      Get.find<AuthService>().redirectRoute.value = route;
    }
    return RouteSettings(name: Routes.LOGIN, arguments: {'redirect': route});
  }
}
