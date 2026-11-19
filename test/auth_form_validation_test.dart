import 'package:e_commerce/app/modules/login/controllers/login_controller.dart';
import 'package:e_commerce/app/modules/register/controllers/register_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginController validation', () {
    late LoginController controller;

    setUp(() {
      controller = LoginController();
    });

    tearDown(() {
      controller.onClose();
    });

    test('validates email format', () {
      expect(controller.validateEmail(''), isNotNull);
      expect(controller.validateEmail('not-an-email'), isNotNull);
      expect(controller.validateEmail('user@example.com'), isNull);
      expect(controller.validateEmail(' user@example.com '), isNull);
    });

    test('requires a password with at least six characters', () {
      expect(controller.validatePassword(''), isNotNull);
      expect(controller.validatePassword('12345'), isNotNull);
      expect(controller.validatePassword('123456'), isNull);
    });
  });

  group('RegisterController validation', () {
    late RegisterController controller;

    setUp(() {
      controller = RegisterController();
    });

    tearDown(() {
      controller.onClose();
    });

    test('validates a non-empty full name', () {
      expect(controller.validateName(' '), isNotNull);
      expect(controller.validateName('A'), isNotNull);
      expect(controller.validateName('Rafi Hamzah'), isNull);
    });

    test('validates email format and password length', () {
      expect(controller.validateEmail('invalid'), isNotNull);
      expect(controller.validateEmail('user@example.com'), isNull);
      expect(controller.validatePassword('12345'), isNotNull);
      expect(controller.validatePassword('123456'), isNull);
    });

    test('requires confirmation to match the password', () {
      controller.passwordController.text = 'secret1';

      expect(controller.validatePasswordConfirmation(''), isNotNull);
      expect(controller.validatePasswordConfirmation('different'), isNotNull);
      expect(controller.validatePasswordConfirmation('secret1'), isNull);
    });
  });
}
