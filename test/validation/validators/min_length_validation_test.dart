import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });
}
