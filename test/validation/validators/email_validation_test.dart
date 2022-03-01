import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    return null;
  }
}

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
    expect(sut.validate('myemail@mail.com'), null);
  });
}
