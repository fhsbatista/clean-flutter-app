import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'validation_composite.mocks.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    return null;
  }
}

@GenerateMocks([FieldValidation])
void main() {
  test('Should return null if all validations returns null or empty', () {
    final validation1 = MockFieldValidation();
    when(validation1.field).thenReturn('any field');
    when(validation1.validate(any)).thenReturn(null);
    final validation2 = MockFieldValidation();
    when(validation2.field).thenReturn('any field');
    when(validation2.validate(any)).thenReturn('');
    final sut = ValidationComposite([validation1, validation2]);

    final error = sut.validate(field: 'any field', value: 'any value');

    expect(error, null);
  });
}
