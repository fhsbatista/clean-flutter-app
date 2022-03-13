import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      valueToCompare: 'any_value',
    );
  });

  test('Should return error if value is not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}
