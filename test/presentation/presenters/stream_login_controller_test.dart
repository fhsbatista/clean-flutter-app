import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_login_controller_test.mocks.dart';

abstract class Validation {
  String? validate({
    required String field,
    required String value,
  });
}

class LoginState {
  String? emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  StreamLoginPresenter({required this.validation});

  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
    _state.emailError = 'any error';
    _controller.add(_state);
  }
}

@GenerateMocks([Validation])
void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;
  late String email;

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
        field: field ?? anyNamed('field'),
        value: anyNamed('value'),
      ));

  void mockValidation({String? field, String? value}) =>
      mockValidationCall(field).thenReturn(value);

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });
  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'any error');

    expectLater(sut.emailErrorStream, emits('any error'));

    sut.validateEmail(email);
  });
}
