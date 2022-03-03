import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'local_save_current_account_test.mocks.dart';

@GenerateMocks([SaveSecureCacheStorage])
void main() {
  late LocalSaveCurrentAccount sut;
  late MockSaveSecureCacheStorage saveSecureCacheStorage;
  late AccountEntity account;

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(
      key: anyNamed('key'),
      value: anyNamed('value'),
    )).thenThrow(Exception());
  }

  setUp(() {
    saveSecureCacheStorage = MockSaveSecureCacheStorage();
    sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
    account = AccountEntity(token: faker.guid.guid());
  });
  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(
      key: 'token',
      value: account.token,
    ));
  });

  test('Should throw unexpected error if SaveSecureCacheStorage throws',
      () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}

