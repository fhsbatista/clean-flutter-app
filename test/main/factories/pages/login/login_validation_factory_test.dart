import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  test('Should return correct Validations', () {
    final sut = makeLoginValidation();
    final expectedValidations = [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', length: 3),
    ];
    
    expect(sut.validations, expectedValidations);
  });
}
