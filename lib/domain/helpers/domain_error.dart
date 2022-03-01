enum DomainError {
  unexpected,
  invalidCredentials,
}

extension DomainErrorError on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais Inválidas';
      case DomainError.unexpected:
        return 'Algo errado aconteceu. Tente novamente em breve.';
      default:
        return '';
    }
  }
}
