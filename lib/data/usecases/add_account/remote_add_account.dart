import 'package:fordev/data/models/models.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/add_account.dart';

import '../../http/http.dart';

class RemoteAddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({
    required this.httpClient,
    required this.url,
  });

  Future<void> add(AddAccountParams params) async {
    try {
      await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAddAccountParams.fromDomain(params).toJson(),
      );
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.emailInUse
          : DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams extends AddAccountParams {
  RemoteAddAccountParams({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) : super(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
