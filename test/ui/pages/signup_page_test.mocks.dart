// Mocks generated by Mockito 5.1.0 from annotations
// in fordev/test/ui/pages/signup_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/ui/helpers/errors/errors.dart' as _i4;
import 'package:fordev/ui/pages/signup/signup_presenter.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [SignUpPresenter].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignUpPresenter extends _i1.Mock implements _i2.SignUpPresenter {
  MockSignUpPresenter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.UIError?> get nameErrorStream => (super.noSuchMethod(
      Invocation.getter(#nameErrorStream),
      returnValue: Stream<_i4.UIError?>.empty()) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<_i4.UIError?> get emailErrorStream => (super.noSuchMethod(
      Invocation.getter(#emailErrorStream),
      returnValue: Stream<_i4.UIError?>.empty()) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<_i4.UIError?> get passwordErrorStream => (super.noSuchMethod(
      Invocation.getter(#passwordErrorStream),
      returnValue: Stream<_i4.UIError?>.empty()) as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<_i4.UIError?> get passwordConfirmationErrorStream =>
      (super.noSuchMethod(Invocation.getter(#passwordConfirmationErrorStream),
              returnValue: Stream<_i4.UIError?>.empty())
          as _i3.Stream<_i4.UIError?>);
  @override
  _i3.Stream<bool> get isFormValidStream =>
      (super.noSuchMethod(Invocation.getter(#isFormValidStream),
          returnValue: Stream<bool>.empty()) as _i3.Stream<bool>);
  @override
  void validateName(String? name) =>
      super.noSuchMethod(Invocation.method(#validateName, [name]),
          returnValueForMissingStub: null);
  @override
  void validateEmail(String? email) =>
      super.noSuchMethod(Invocation.method(#validateEmail, [email]),
          returnValueForMissingStub: null);
  @override
  void validatePassword(String? password) =>
      super.noSuchMethod(Invocation.method(#validatePassword, [password]),
          returnValueForMissingStub: null);
  @override
  void validatePasswordConfirmation(String? passwordConfirmation) =>
      super.noSuchMethod(
          Invocation.method(
              #validatePasswordConfirmation, [passwordConfirmation]),
          returnValueForMissingStub: null);
  @override
  void signUp() => super.noSuchMethod(Invocation.method(#signUp, []),
      returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
}
