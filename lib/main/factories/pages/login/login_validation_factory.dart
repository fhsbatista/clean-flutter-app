import 'package:fordev/main/builders/validation_builder.dart';
import 'package:fordev/validation/validators/validators.dart';
import '../../../builders/builders.dart';

ValidationComposite makeLoginValidation() {
  return ValidationComposite([
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build(),
  ]);
}
