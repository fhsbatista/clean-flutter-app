import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'getx_login_presenter_test.mocks.dart';

@GenerateMocks([Validation, Authentication, SaveCurrentAccount])
void main() {
  late GetxLoginPresenter sut;
  late MockValidation validation;
  late MockAuthentication authentication;
  late MockSaveCurrentAccount saveCurrentAccount;
  late String email;
  late String password;
  late String token;

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
        field: field ?? anyNamed('field'),
        value: anyNamed('value'),
      ));

  void mockValidation({String? field, String? value}) =>
      mockValidationCall(field).thenReturn(value);

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication({String? field, String? value}) =>
      mockAuthenticationCall()
          .thenAnswer((_) async => AccountEntity(token: token));

  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() =>
      mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);

  setUp(() {
    validation = MockValidation();
    authentication = MockAuthentication();
    saveCurrentAccount = MockSaveCurrentAccount();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAuthentication();
  });
  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'any error');

    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.emailErrorStream.listen(expectAsync1((e) => expect(e, 'any error')));
    sut.isFormValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    //Calling validation twice so the test can ensure the error will be emitted only once.
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.emailErrorStream.listen(expectAsync1((e) => expect(e, null)));
    sut.isFormValidStream.listen(expectAsync1((valid) => expect(valid, false)));

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
    sut.passwordErrorStream.listen(expectAsync1((e) => expect(e, 'any error')));
    sut.isFormValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    //Calling validation twice so the test can ensure the error will be emitted only once.
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation succeeds', () {
    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.passwordErrorStream.listen(expectAsync1((e) => expect(e, null)));
    sut.isFormValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    //Calling validation twice so the test can ensure the error will be emitted only once.
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.emailErrorStream.listen(expectAsync1((e) => expect(e, 'error')));
    sut.passwordErrorStream.listen(expectAsync1((e) => expect(e, null)));
    sut.isFormValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    //Calling each validation twice so the test can ensure the error will be emitted only once.
    sut.validateEmail(email);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit true on IsFormValidStream if validation succeeds',
      () async {
    //This way of "expect" ensures the stream will not emit the same value more than once.
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream.listen(expectAsync1((e) => expect(e, null)));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should call authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(
      authentication.auth(
        AuthenticationParams(email: email, password: password),
      ),
    );
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token: token))).called(1);
  });

  test('Should emit Unexpected error on SaveCurrentAccount failure', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((e) {
      expect(e, 'Algo errado aconteceu. Tente novamente em breve.');
    }));

    await sut.auth();
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test(
      'Should emit correct events on Authentication failure with invalid credentials error',
      () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((e) {
      expect(e, 'Credenciais Inválidas');
    }));

    await sut.auth();
  });

  test(
      'Should emit correct events on Authentication failure with unexpected error',
      () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((e) {
      expect(e, 'Algo errado aconteceu. Tente novamente em breve.');
    }));

    await sut.auth();
  });

  test('Should change page to surveys on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(expectAsync1((page) {
      expect(page, '/surveys');
    }));

    await sut.auth();
  });
}
