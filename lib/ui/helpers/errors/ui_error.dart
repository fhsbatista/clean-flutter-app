import '../i18n/i18n.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
}

extension UIErrorError on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return I18n.strings.msgRequiredField;
      case UIError.invalidField:
        return I18n.strings.msgInvalidField;
      case UIError.invalidCredentials:
        return I18n.strings.msgInvalidCredentials;
      case UIError.emailInUse:
        return I18n.strings.msgEmailInUse;
      default:
        return I18n.strings.msgUnexpectedError;
    }
  }
}
