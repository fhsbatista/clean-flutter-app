import '../../validation/protocols/field_validation.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static late ValidationBuilder _instance;
  late String _fieldName;
  List<FieldValidation> _validations = [];

  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance._fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    _validations.add(RequiredFieldValidation(_fieldName));
    return this;
  }

  ValidationBuilder email() {
    _validations.add(EmailValidation(_fieldName));
    return this;
  }

  ValidationBuilder min(int length) {
    _validations.add(MinLengthValidation(field: _fieldName, length: length));
    return this;
  }

  List<FieldValidation> build() => _validations;
}
