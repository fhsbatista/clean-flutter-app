import 'package:fordev/main/builders/validation_builder.dart';
import '../../../composites/composites.dart';
import '../../../builders/builders.dart';

ValidationComposite makeSignUpValidation() {
  return ValidationComposite([
    ...ValidationBuilder.field('name').required().min(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('passwordConfirmation')
        .required()
        .min(3)
        .build(),
  ]);
}
