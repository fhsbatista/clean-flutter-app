import 'dart:async';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:get/get.dart';

import '../protocols/validation.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  String _name = '';
  String _email = '';
  String _password = '';
  String _passwordConfirmation = '';

  var _nameError = Rx<UIError?>(null);
  var _emailError = Rx<UIError?>(null);
  var _passwordError = Rx<UIError?>(null);
  var _passwordConfirmationError = Rx<UIError?>(null);
  var _isFormValid = false.obs;
  var _mainError = Rx<UIError?>(null);
  var _isLoading = false.obs;
  var _navigateTo = Rx<String?>(null);

  Stream<UIError?> get nameErrorStream => _nameError.stream;
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String?> get navigateToStream => _navigateTo.stream;

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

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

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(
      field: 'passwordConfirmation',
      value: passwordConfirmation,
    );
    _validateForm();
  }

  UIError? _validateField({required String field, required String value}) {
    final error = validation.validate(field: field, value: value);
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
    _isFormValid.value = _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name.isNotEmpty &&
        _email.isNotEmpty &&
        _password.isNotEmpty &&
        _passwordConfirmation.isNotEmpty;
  }

  Future<void> signUp() async {
    _isLoading.value = true;
    try {
      final params = AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      );
      final account = await addAccount.add(params);
      saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _isLoading.value = false;
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
    }
  }

  void dispose() {
    super.dispose();
  }
}
