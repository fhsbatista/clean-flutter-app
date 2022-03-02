import 'dart:async';

import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  String _email = '';
  String _password = '';
  var _emailError = Rx<String?>(null);
  var _passwordError = Rx<String?>(null);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;
  var _mainError = Rx<String?>(null);

  Stream<String?> get emailErrorStream => _emailError.stream;
  Stream<String?> get passwordErrorStream => _passwordError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String?> get mainErrorStream => _mainError.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(
      field: 'email',
      value: email,
    );
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate(
      field: 'password',
      value: password,
    );
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email.isNotEmpty &&
        _password.isNotEmpty;
  }

  Future<dynamic> auth() async {
    _isLoading.value = true;
    try {
      await authentication.auth(
        AuthenticationParams(email: _email, password: _password),
      );
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }
    _isLoading.value = false;
  }

  void dispose() {
    super.dispose();
  }
}
