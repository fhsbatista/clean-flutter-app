import './translations.dart';

class EnUs implements Translations {
  String get appTitle => 'ForDev';

  String get msgRequiredField => 'Required field';
  String get msgInvalidField => 'Invalid field';
  String get msgInvalidCredentials => 'Invalid credentials';
  String get msgUnexpectedError => 'Something went wrong. Try again later.';
  String get msgEmailInUse => 'The email is already in use.';

  String get getIn => 'Get in';
  String get holdOn => 'Hold on...';
  String get login => 'Login';
  String get addAccount => 'Create Account';
  String get name => 'Name';
  String get email => 'Email';
  String get password => 'Password';
  String get confirmPassword => 'Confirm password';
  String get surveys => 'Surveys';
  String get reload => 'Recarregar';
}
