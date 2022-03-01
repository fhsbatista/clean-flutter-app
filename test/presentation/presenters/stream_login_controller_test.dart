import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';

import 'package:fordev/presentation/dependencies/dependencies.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'stream_login_controller_test.mocks.dart';

@GenerateMocks([Validation, Authentication])
void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;
  late MockAuthentication authentication;
  late String email;
  late String password;

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
        field: field ?? anyNamed('field'),
        value: anyNamed('value'),
      ));

  void mockValidation({String? field, String? value}) =>
      mockValidationCall(field).thenReturn(value);

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication({String? field, String? value}) =>
      mockAuthenticationCall()
          .thenAnswer((_) async => AccountEntity(token: faker.guid.guid()));

  setUp(() {
    validation = MockValidation();
    authentication = MockAuthentication();
    sut = StreamLoginPresenter(
      validation: validation,
      authentication: authentication,
    );
    email = faker.internet.email();
    password = faker.internet.password();
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
    //Necessary so that there is time to make the "expect later" catch de values.
    //It was necessary on the previous tests because the "expectAsync" takes care of this.
    await Future.delayed(Duration.zero);
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

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });
}
