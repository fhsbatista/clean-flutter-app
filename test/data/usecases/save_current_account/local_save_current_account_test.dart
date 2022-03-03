import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_save_current_account_test.mocks.dart';

@GenerateMocks([SaveSecureCacheStorage])
void main() {
  test('Should call SaveSecureCacheStorage with correct values', () async {
    final saveSecureCacheStorage = MockSaveSecureCacheStorage();
    final sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
    final account = AccountEntity(token: faker.guid.guid());

    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(
      key: 'token',
      value: account.token,
    ));
  });
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({String key, String value});
}

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}
