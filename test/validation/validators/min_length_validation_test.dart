import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late MinLengthValidation sut;
  late int minimum;

  setUp(() {
    minimum = 5;
    sut = MinLengthValidation(field: 'any_field', length: minimum);
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });

  test('Should return error if value length is less than minimum', () {
    final input = faker.randomGenerator.string(minimum -1, min: 1);
    expect(sut.validate(input), ValidationError.invalidField);
  });

  test('Should return null if value length is equal to minimum', () {
    final input = faker.randomGenerator.string(minimum, min: minimum);
    expect(sut.validate(input), null);
  });

  test('Should return null if value length is greater than minimum', () {
    final input = faker.randomGenerator.string(minimum + 5, min: minimum + 1);
    expect(sut.validate(input), null);
  });
}
