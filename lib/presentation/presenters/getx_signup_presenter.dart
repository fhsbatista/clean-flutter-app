import 'dart:async';

import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:get/get.dart';

import '../protocols/validation.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  GetxSignUpPresenter({
    required this.validation,
  });

  var _emailError = Rx<UIError?>(null);
  var _isFormValid = false.obs;

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
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
    _isFormValid.value = false;
  }

  void dispose() {
    super.dispose();
  }
}
