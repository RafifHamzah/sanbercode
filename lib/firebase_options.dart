// GENERATED CONFIGURATION - Firebase project kicksstore-smk-flutter-b0e61
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase belum dikonfigurasi untuk platform ini.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBc77mhXQ2Q32i5RqN5HZ-j9AxGkdCmdzM',
    appId: '1:874230170723:android:6a56d96ace3cbf0a27a456',
    messagingSenderId: '874230170723',
    projectId: 'kicksstore-smk-flutter-b0e61',
    storageBucket: 'kicksstore-smk-flutter-b0e61.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDhM2quJ5gT3fO-IYpY5GcMZ0aCS0eHnM',
    appId: '1:874230170723:ios:212aa48e12730f1c27a456',
    messagingSenderId: '874230170723',
    projectId: 'kicksstore-smk-flutter-b0e61',
    storageBucket: 'kicksstore-smk-flutter-b0e61.firebasestorage.app',
    iosBundleId: 'com.ecommerce.eCommerce',
  );
}
