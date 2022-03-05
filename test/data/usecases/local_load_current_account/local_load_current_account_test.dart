import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'local_load_current_account_test.mocks.dart';

@GenerateMocks([FetchSecureCacheStorage])
void main() {
  late LocalLoadCurrentAccount sut;
  late MockFetchSecureCacheStorage fetchSecureCacheStorage;
  late String token;

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecure() =>
      mockFetchSecureCall().thenAnswer((_) async => token);

  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}




