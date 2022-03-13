import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation({
    required this.field,
    required this.valueToCompare,
  });

  @override
  ValidationError? validate(String? value) {
    value ??= '';
    return value == valueToCompare ? null : ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [field, valueToCompare];
}
