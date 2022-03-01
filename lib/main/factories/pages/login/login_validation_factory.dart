import 'package:fordev/validation/validators/validators.dart';

ValidationComposite makeLoginValidation() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
}
