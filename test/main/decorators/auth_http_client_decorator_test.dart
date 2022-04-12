import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/main/decorators/auth_http_client_decorator.dart';

import 'auth_http_client_decorator_test.mocks.dart';

@GenerateMocks([FetchSecureCacheStorage])
void main() {
  late AuthHttpClientDecorator sut;
  late MockFetchSecureCacheStorage fetchSecureCacheStorage;
  late String url;
  late String method;

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    sut = AuthHttpClientDecorator(fetchSecureCacheStorage);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    when(fetchSecureCacheStorage.fetchSecure(any))
        .thenAnswer((_) async => 'any_token');
  });

  test('should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method);

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}