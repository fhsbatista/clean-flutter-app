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
  late String email;

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
        field: field ?? anyNamed('field'),
        value: anyNamed('value'),
      ));

  void mockValidation({String? field, ValidationError? value}) =>
      mockValidationCall(field).thenReturn(value);

  setUp(() {
    email = faker.internet.email();
    validation = MockValidation();
    sut = GetxSignUpPresenter(validation: validation);
    mockValidation();
  });

  group('email validation', () {
    test('Should call validation with correct email', () async {
      sut.validateEmail(email);
      verify(sut.validateEmail(email)).called(1);
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
}
