import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/auth_http_client_decorator.dart';

import 'auth_http_client_decorator_test.mocks.dart';

@GenerateMocks([FetchSecureCacheStorage, HttpClient])
void main() {
  late AuthHttpClientDecorator sut;
  late MockFetchSecureCacheStorage fetchSecureCacheStorage;
  late MockHttpClient httpClient;
  late String url;
  late String method;
  late String token;

  void mockToken() {
    token = faker.guid.guid();
    when(fetchSecureCacheStorage.fetchSecure(any))
        .thenAnswer((_) async => token);
  }

  void mockDecoratee() {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => null);
  }

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    httpClient = MockHttpClient();
    sut = AuthHttpClientDecorator(fetchSecureCacheStorage, httpClient);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    mockToken();
    mockDecoratee();
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method);

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with token on header', () async {
    await sut.request(url: url, method: method);

    verify(httpClient.request(
      url: url,
      method: method,
      headers: {'x-access-token': token},
      body: {}
    )).called(1);
  });
}
