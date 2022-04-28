import 'dart:async';

import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';
import '../protocols/validation.dart';

class GetxLoginPresenter extends GetxController
    with GetxLoading, GetxNavigation, GetxMainError, GetxFormValidation
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  String _email = '';
  String _password = '';
  var _emailError = Rx<UIError?>(null);
  var _passwordError = Rx<UIError?>(null);

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  UIError? _validateField({required String field, required String value}) {
    final error = validation.validate(
      field: field,
      value: value,
    );
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid = _emailError.value == null &&
        _passwordError.value == null &&
        _email.isNotEmpty &&
        _password.isNotEmpty;
  }

  @override
  Future<dynamic> auth() async {
    mainError = null;
    isLoading = true;
    try {
      final account = await authentication.auth(
        AuthenticationParams(email: _email, password: _password),
      );
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
    }
    isLoading = false;
  }

  @override
  void signUp() {
    navigateTo = '/signup';
  }

  void dispose() {
    super.dispose();
  }
}
