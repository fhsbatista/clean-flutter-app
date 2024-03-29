import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/authentication.dart';

import '../../models/models.dart';
import '../../http/http.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams extends AuthenticationParams {
  RemoteAuthenticationParams({
    required String email,
    required String password,
  }) : super(
          email: email,
          password: password,
        );

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.password,
      );

  Map toJson() => {
        'email': email,
        'password': password,
      };
}
