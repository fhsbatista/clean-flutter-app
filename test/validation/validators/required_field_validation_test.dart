import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/validation/validators/validators.dart';
void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any field'); 
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any value'), null);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });
}
