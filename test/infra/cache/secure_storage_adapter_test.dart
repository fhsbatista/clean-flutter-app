import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/infra/cache/cache.dart';

import 'secure_storage_adapter_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late SecureStorageAdapter sut;
  late MockFlutterSecureStorage secureStorage;
  late String key;
  late String value;
  final exception = Exception('any error');

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.lorem.word();
  });

  group('saveSecure', () {
    void mockSaveSecureError() {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(exception);
    }

    test('Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      mockSaveSecureError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(exception));
    });
  });

  group('fetchSecure', () {
    PostExpectation mockFetchSecureCall() =>
        when(secureStorage.read(key: anyNamed('key')));

    void mockFetchSecure() =>
        mockFetchSecureCall().thenAnswer((_) async => value);

    void mockFetchSecureError() => mockFetchSecureCall().thenThrow(exception);

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct values', () async {
      await sut.fetch(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });

    test('Should throw if save secure throws', () async {
      mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(exception));
    });
  });

  group('delete', () {
    void mockDeleteSecureError() {
      when(secureStorage.delete(key: anyNamed('key'))).thenThrow(exception);
    }

    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if delete throws', () async {
      mockDeleteSecureError();

      final future = sut.delete(key);

      expect(() => future, throwsA(isA<Exception>()));
    });
  });
}
