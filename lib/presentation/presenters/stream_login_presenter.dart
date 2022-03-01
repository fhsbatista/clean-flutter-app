import 'dart:async';

import '../../domain/usecases/usecases.dart';

import '../dependencies/validation.dart';

class LoginState {
  String email = '';
  String password = '';
  String? emailError;
  String? passwordError;
  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;

  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<String?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool?> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  Stream<bool?> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading).distinct();

  void _updateState() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );
    _updateState();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
    );
    _updateState();
  }

  Future<dynamic> auth() async {
    _state.isLoading = true;
    _updateState();
    await authentication.auth(
      AuthenticationParams(
        email: _state.email,
        password: _state.password,
      ),
    );
    _state.isLoading = false;
    _updateState();
  }
}
