import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/presentation/dependencies/dependencies.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'stream_login_controller_test.mocks.dart';

@GenerateMocks([Validation])
void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;
  late String email;
  late String password;

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
    password = faker.internet.password();
    mockValidation();
  });
  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'any error');

    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, 'any error')),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    //Calling validation twice so the test can ensure the error will be emitted only once.
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    //Calling validation twice so the test can ensure the error will be emitted only once.
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'any error');

    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, 'any error')),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    //Calling validation twice so the test can ensure the error will be emitted only once.
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation succeeds', () {
    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );

    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    //Calling validation twice so the test can ensure the error will be emitted only once.
    sut.validatePassword(password);
    sut.validatePassword(password);
  });
}
