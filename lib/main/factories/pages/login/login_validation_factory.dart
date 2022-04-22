import 'package:fordev/main/builders/validation_builder.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

ValidationComposite makeLoginValidation() {
  return ValidationComposite([
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ]);
}
