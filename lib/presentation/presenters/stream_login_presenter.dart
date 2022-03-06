import 'dart:async';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../protocols/validation.dart';

class LoginState {
  String email = '';
  String password = '';
  UIError? emailError;
  UIError? passwordError;
  UIError? mainError;
  bool isLoading = false;
  String? navigateTo;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  Stream<UIError?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<UIError?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading).distinct();

  Stream<UIError?> get mainErrorStream =>
      _controller.stream.map((state) => state.mainError).distinct();

  Stream<String?> get navigateToStream =>
      _controller.stream.map((state) => state.navigateTo).distinct();

  void _updateState() {
    if (_controller.isClosed) {
      return;
    }
    _controller.add(_state);
  }

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validateField(field: 'email', value: email);
    _updateState();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validateField(field: 'password', value: password);
    _updateState();
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

  Future<dynamic> auth() async {
    _state.isLoading = true;
    _updateState();
    try {
      await authentication.auth(
        AuthenticationParams(
          email: _state.email,
          password: _state.password,
        ),
      );
    } on DomainError catch (error) {switch (error) {
        case DomainError.invalidCredentials:
          _state.mainError = UIError.invalidCredentials;
          break;
        default:
          _state.mainError = UIError.unexpected;
          break;
      }
    }

    _state.isLoading = false;
    _updateState();
  }

  void dispose() {
    _controller.close();
  }
}
