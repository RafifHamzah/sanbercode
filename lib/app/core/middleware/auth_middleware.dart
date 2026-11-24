import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final preferences = Get.isRegistered<SharedPreferences>()
        ? Get.find<SharedPreferences>()
        : null;
    if (preferences?.getBool('isLoggedIn') == true) return null;

    return RouteSettings(name: Routes.LOGIN, arguments: {'redirect': route});
  }
}
