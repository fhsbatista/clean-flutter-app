import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/main/decorators/decorators.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/http/http.dart';

import 'auth_http_client_decorator_test.mocks.dart';

@GenerateMocks([FetchSecureCacheStorage, DeleteSecureCacheStorage, HttpClient])
void main() {
  late AuthHttpClientDecorator sut;
  late MockFetchSecureCacheStorage fetchSecureCacheStorage;
  late MockDeleteSecureCacheStorage deleteSecureCacheStorage;
  late MockHttpClient httpClient;
  late String url;
  late String method;
  late String token;
  late String decorateeResponse;

  PostExpectation whenTokenCall() {
    return when(fetchSecureCacheStorage.fetchSecure(any));
  }

  void mockToken() {
    token = faker.guid.guid();
    whenTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    whenTokenCall().thenThrow(Exception());
  }

  PostExpectation whenDecorateeCall() {
    return when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    ));
  }

  void mockDecoratee() {
    decorateeResponse = faker.randomGenerator.string(50);
    whenDecorateeCall().thenAnswer((_) async => decorateeResponse);
  }

  void mockDecorateeError(HttpError error) {
    whenDecorateeCall().thenThrow(error);
  }

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    deleteSecureCacheStorage = MockDeleteSecureCacheStorage();
    httpClient = MockHttpClient();
    sut = AuthHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      deleteSecureCacheStorage: deleteSecureCacheStorage,
      decoratee: httpClient,
    );
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
        body: {})).called(1);
  });

  test(
    'Should call decoratee with token on header without modifying original headers',
    () async {
      await sut.request(
        url: url,
        method: method,
        headers: {'header1': 'header1-value'},
      );

      verify(httpClient.request(
        url: url,
        method: method,
        headers: {
          'x-access-token': token,
          'header1': 'header1-value',
        },
        body: {},
      )).called(1);
    },
  );

  test('Should return same result as decoratee', () async {
    final response = await sut.request(
      url: url,
      method: method,
    );

    expect(response, decorateeResponse);
  });

  test(
    'Should throw Forbidden error if FetchSecureCacheStorage throws and delete token on storage',
    () async {
      mockTokenError();

      final future = sut.request(
        url: url,
        method: method,
      );

      expect(future, throwsA(HttpError.forbidden));
      verify(deleteSecureCacheStorage.deleteSecure('token')).called(1);
    },
  );

  test(
    'Should rethrow if decoratee throws',
    () async {
      mockDecorateeError(HttpError.badRequest);

      final future = sut.request(
        url: url,
        method: method,
      );

      expect(future, throwsA(HttpError.badRequest));
    },
  );

  test(
    'Should delete token on cache if request throws forbidden error',
    () async {
      mockDecorateeError(HttpError.forbidden);

      final future = sut.request(
        url: url,
        method: method,
      );

      expect(future, throwsA(HttpError.forbidden));
      await untilCalled(deleteSecureCacheStorage.deleteSecure('token'));
      verify(deleteSecureCacheStorage.deleteSecure('token')).called(1);
    },
  );
}
