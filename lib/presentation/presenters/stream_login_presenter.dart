import 'dart:async';

import '../dependencies/validation.dart';

class LoginState {
  String? emailError;
  String? passwordError;
  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  StreamLoginPresenter({required this.validation});

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<String?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool?> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  void _updateState() => _controller.add(_state);

  void validateEmail(String email) {
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );
    _updateState();
  }

  void validatePassword(String password) {
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
    );
    _updateState();
  }
}
