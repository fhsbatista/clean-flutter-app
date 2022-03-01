import '../protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    for (final validation in validations.where((e) => e.field == field)) {
      final error = validation.validate(value);
      if (error?.isNotEmpty ?? false) {
        return error;
      }
    }
    return null;
  }
}