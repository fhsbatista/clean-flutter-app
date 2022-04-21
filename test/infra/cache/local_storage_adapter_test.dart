import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/infra/cache/cache.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_storage_adapter_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late LocalStorageAdapter sut;
  late MockLocalStorage localStorage;
  late String key;
  late String value;

  void mockDeleteItemError() {
    when(localStorage.deleteItem(any)).thenThrow(Exception());
  }

  void mockSetItemError() {
    when(localStorage.setItem(any, any)).thenThrow(Exception());
  }

  void mockGetItem(String value) {
    when(localStorage.getItem(any)).thenAnswer((_) async => value);
  }

  void mockGetItemError() {
    when(localStorage.getItem(any)).thenThrow(Exception());
  }

  setUp(() {
    localStorage = MockLocalStorage();
    sut = LocalStorageAdapter(localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(100);
    mockGetItem('any_value');
  });

  group('save', () {
    test('Should call local storage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if delete throws', () async {
      mockDeleteItemError();

      final future = sut.save(key: key, value: value);

      expect(() => future, throwsA(isA<Exception>()));
    });

    test('Should throw if set throws', () async {
      mockSetItemError();

      final future = sut.save(key: key, value: value);

      expect(() => future, throwsA(isA<Exception>()));
    });
  });

  group('delete', () {
    test('Should call local storage with correct values', () async {
      await sut.delete(key);

      verify(localStorage.deleteItem(key)).called(1);
    });

    test('Should throw if delete throws', () async {
      mockDeleteItemError();

      final future = sut.delete(key);

      expect(() => future, throwsA(isA<Exception>()));
    });
  });

  group('fetch', () {
    test('Should call local storage with correct values', () async {
      await sut.fetch(key);

      verify(localStorage.getItem(key)).called(1);
    });

    test('Should return same value as local storage', () async {
      final storedValue = 'any_value';
      mockGetItem(storedValue);

      final result = await sut.fetch(key);

      expect(result, storedValue);
    });

    test('Should throw if fetch throws', () async {
      mockGetItemError();

      final future = sut.fetch(key);

      expect(() => future, throwsA(isA<Exception>()));
    });
  });
}
