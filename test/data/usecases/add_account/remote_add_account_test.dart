import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/add_account.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'remote_add_account_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteAddAccount sut;
  late MockHttpClient httpClient;
  late String url;
  late AddAccountParams params;

  Map getValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      );

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttpData(getValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'name': params.name,
        'email': params.email,
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation,
      },
    )).called(1);
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw emailInUse error if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });
}
