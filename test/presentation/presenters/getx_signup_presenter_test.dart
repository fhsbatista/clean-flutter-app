import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/add_account.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:mockito/mockito.dart';

import 'getx_signup_presenter_test.mocks.dart';

@GenerateMocks([Validation, AddAccount])
void main() {
  late GetxSignUpPresenter sut;
  late MockValidation validation;
  late MockAddAccount addAccount;
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
        field: field ?? anyNamed('field'),
        value: anyNamed('value'),
      ));

  void mockValidation({String? field, ValidationError? value}) =>
      mockValidationCall(field).thenReturn(value);

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccount() => mockAddAccountCall()
      .thenAnswer((_) async => AccountEntity(token: faker.guid.guid()));

  setUp(() {
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    addAccount = MockAddAccount();
    validation = MockValidation();
    sut = GetxSignUpPresenter(validation: validation, addAccount: addAccount);
    mockValidation();
    mockAddAccount();
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

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });

  group('passwordConfirmation validation', () {
    test('Should call validation with correct passwordConfirmation', () async {
      sut.validatePasswordConfirmation(passwordConfirmation);
      verify(validation.validate(
              field: 'passwordConfirmation', value: passwordConfirmation))
          .called(1);
    });

    test('Should emit invalid field error if passwordConfirmation is invalid',
        () {
      mockValidation(value: ValidationError.invalidField);

      sut.passwordConfirmationErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.invalidField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Should emit required field error if passwordConfirmation is empty',
        () {
      mockValidation(value: ValidationError.requiredField);

      sut.passwordConfirmationErrorStream.listen(expectAsync1(
        (e) => expect(e, UIError.requiredField),
      ));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Should emit null if validation succeeds', () {
      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((e) => expect(e, null)));
      sut.isFormValidStream.listen(
        expectAsync1((valid) => expect(valid, false)),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });
  });

  test('Should emit true on IsFormValidStream if validation succeeds',
      () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(
      addAccount.add(
        AddAccountParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      ),
    );
  });
}
