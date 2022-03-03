import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/infra/cache/cache.dart';

import 'local_storage_adapter_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late LocalStorageAdapter sut;
  late MockFlutterSecureStorage secureStorage;
  late String key;
  late String value;

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.lorem.word();
  });

  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  test('Should throw if save secure throws', () async {
    final exception = Exception('any error');
    when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(exception);

    final future = sut.saveSecure(key: key, value: value);

    expect(future, throwsA(exception));
  });
}