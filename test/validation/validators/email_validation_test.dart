import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any field');
  });

  test('Should return null if email is empty or null', () {
    expect(sut.validate(''), null);
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate(faker.internet.email()), null);
  });

  test('Should return error if email is not valid', () {
    expect(sut.validate('myemailmail.com'), ValidationError.invalidField);
  });
}
