import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/services/auth_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/local/product_local_datasource.dart';
import 'app/data/local/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final preferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(preferences, permanent: true);

  final storageService = await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );

  await Get.putAsync<AuthService>(
    () => AuthService().init(prefs: preferences),
    permanent: true,
  );

  await Get.putAsync<ProductLocalDataSource>(() async {
    final localDataSource = ProductLocalDataSourceImpl();
    await localDataSource.init();
    return localDataSource;
  }, permanent: true);

  runApp(
    GetMaterialApp(
      title: "KicksStore",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storageService.themeMode,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
