import 'package:fordev/domain/entities/account_entity.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  AddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}
