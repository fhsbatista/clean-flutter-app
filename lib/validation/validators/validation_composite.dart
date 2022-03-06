import '../protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError? validate({required String field, required String value}) {
    for (final validation in validations.where((e) => e.field == field)) {
      final error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}