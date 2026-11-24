import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AuthService extends GetxService {
  static const _loggedInKey = 'isLoggedIn';
  static const _loggedInEmailKey = 'loggedInEmail';

  late final FirebaseAuth _auth;
  late final SharedPreferences _prefs;
  StreamSubscription<User?>? _authSubscription;
  final currentUser = Rxn<User>();
  final isLoggedIn = false.obs;
  final currentUserEmail = ''.obs;
  final currentUserId = ''.obs;
  final redirectRoute = RxnString();

  Future<AuthService> init({required SharedPreferences prefs}) async {
    _prefs = prefs;
    _auth = FirebaseAuth.instance;
    if (_prefs.getBool(_loggedInKey) != true && _auth.currentUser != null) {
      await _auth.signOut();
    }
    _syncUser(_auth.currentUser);
    _authSubscription = _auth.authStateChanges().listen(_syncUser);
    return this;
  }

  void _syncUser(User? user) {
    currentUser.value = user;
    isLoggedIn.value = user != null;
    currentUserEmail.value = user?.email ?? '';
    currentUserId.value = user?.uid ?? '';
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();
    _syncUser(_auth.currentUser);
    await _prefs.setBool(_loggedInKey, true);
    await _prefs.setString(_loggedInEmailKey, email);
    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _syncUser(credential.user);
    return credential;
  }

  Future<void> setRememberMe(bool remember, {String? email}) async {
    await _prefs.setBool(_loggedInKey, remember && isLoggedIn.value);
    if (remember && email != null) {
      await _prefs.setString(_loggedInEmailKey, email);
    } else {
      await _prefs.remove(_loggedInEmailKey);
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut({bool preserveEmail = false}) async {
    await _auth.signOut();
    _syncUser(null);
    await _prefs.setBool(_loggedInKey, false);
    if (!preserveEmail) {
      await _prefs.remove(_loggedInEmailKey);
    }
    redirectRoute.value = null;
  }

  String mapFirebaseAuthError(FirebaseAuthException error) {
    return switch (error.code) {
      'email-already-in-use' => 'Email ini sudah terdaftar.',
      'invalid-email' => 'Format email tidak valid.',
      'weak-password' => 'Kata sandi terlalu lemah.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Email atau kata sandi tidak cocok.',
      'network-request-failed' => 'Periksa koneksi internet Anda.',
      _ => error.message ?? 'Terjadi kesalahan autentikasi.',
    };
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
