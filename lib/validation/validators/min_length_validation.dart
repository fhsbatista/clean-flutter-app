import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int length;

  MinLengthValidation({
    required this.field,
    required this.length,
  });

  @override
  ValidationError? validate(String? value) {
    return ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [field, length];
}
