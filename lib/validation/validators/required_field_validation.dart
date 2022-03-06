import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  ValidationError? validate(String value) {
    return value.isEmpty ? ValidationError.requiredField : null;
  }

  @override
  List<Object?> get props => [field];
}