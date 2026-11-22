import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const _darkThemeKey = 'isDarkTheme';

  late final SharedPreferences _preferences;
  late ThemeMode themeMode;

  Future<StorageService> init() async {
    await Hive.initFlutter();
    _preferences = await SharedPreferences.getInstance();
    themeMode = _preferences.getBool(_darkThemeKey) == true
        ? ThemeMode.dark
        : ThemeMode.light;
    return this;
  }

  Future<void> toggleTheme() async {
    final nextTheme = themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    final saved = await _preferences.setBool(
      _darkThemeKey,
      nextTheme == ThemeMode.dark,
    );
    if (!saved) {
      throw StateError('Gagal menyimpan preferensi tema.');
    }

    themeMode = nextTheme;
    Get.changeThemeMode(nextTheme);
    Get.snackbar(
      'Tema Diperbarui',
      nextTheme == ThemeMode.dark
          ? 'Mode gelap diaktifkan.'
          : 'Mode terang diaktifkan.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: nextTheme == ThemeMode.dark
          ? const Color(0xFF26334A)
          : const Color(0xFF10B981),
      colorText: Colors.white,
      icon: Icon(
        nextTheme == ThemeMode.dark
            ? Icons.dark_mode_rounded
            : Icons.light_mode_rounded,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
