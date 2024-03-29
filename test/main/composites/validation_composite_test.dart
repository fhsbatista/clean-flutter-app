import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/main/composites/composites.dart';

import 'validation_composite_test.mocks.dart';

@GenerateMocks([FieldValidation])
void main() {
  late ValidationComposite sut;
  late MockFieldValidation validation1;
  late MockFieldValidation validation2;
  late MockFieldValidation validation3;

  void mockValidation1(ValidationError? error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(ValidationError? error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(ValidationError? error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = MockFieldValidation();
    validation2 = MockFieldValidation();
    validation3 = MockFieldValidation();
    when(validation1.field).thenReturn('any field');
    when(validation2.field).thenReturn('other field');
    when(validation3.field).thenReturn('other field');
    mockValidation1(null);
    mockValidation2(null);
    mockValidation3(null);
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null', () {
    final error = sut.validate(field: 'any field', value: 'any value');

    expect(error, null);
  });

  test('Should return the first error found by validations', () {
    mockValidation1(null);
    mockValidation2(null);
    mockValidation3(ValidationError.invalidField);

    final error = sut.validate(field: 'other field', value: 'any value');

    expect(error, ValidationError.invalidField);
  });
}
