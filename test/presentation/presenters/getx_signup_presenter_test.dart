import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:mockito/mockito.dart';

import 'getx_signup_presenter_test.mocks.dart';

@GenerateMocks([Validation])
void main() {
  late GetxSignUpPresenter sut;
  late MockValidation validation;
  late String name;
  late String email;
  late String password;

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
        field: field ?? anyNamed('field'),
        value: anyNamed('value'),
      ));

  void mockValidation({String? field, ValidationError? value}) =>
      mockValidationCall(field).thenReturn(value);

  setUp(() {
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    validation = MockValidation();
    sut = GetxSignUpPresenter(validation: validation);
    mockValidation();
  });

  group('name validation', () {
    test('Should call validation with correct name', () async {
      sut.validateName(name);
      verify(validation.validate(field: 'name', value: name)).called(1);
    });

    test('Should emit invalid field error if name is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.nameErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.invalidField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Should emit required field error if name is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.nameErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.requiredField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Should emit null if validation succeeds', () {
      sut.nameErrorStream.listen(expectAsync1((e) => expect(e, null)));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validateName(name);
      sut.validateName(name);
    });
  });

  group('email validation', () {
    test('Should call validation with correct email', () async {
      sut.validateEmail(email);
      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('Should emit invalid field error if email is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.emailErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.invalidField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit required field error if email is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.emailErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.requiredField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit null if validation succeeds', () {
      sut.emailErrorStream.listen(expectAsync1((e) => expect(e, null)));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });

  group('password validation', () {
    test('Should call validation with correct password', () async {
      sut.validatePassword(password);
      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('Should emit invalid field error if password is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.passwordErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.invalidField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit required field error if password is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.passwordErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.requiredField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit null if validation succeeds', () {
      sut.passwordErrorStream.listen(expectAsync1((e) => expect(e, null)));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validatePassword(name);
      sut.validatePassword(name);
    });
  });
}
