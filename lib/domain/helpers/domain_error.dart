enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorError on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais Inválidas';
      default:
        return '';
    }
  }
}
