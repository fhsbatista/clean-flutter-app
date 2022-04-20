import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/infra/cache/local_storage_adapter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_storage_adapter_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late LocalStorageAdapter sut;
  late LocalStorage localStorage;
  late String key;
  late String value;

  setUp(() {
    localStorage = MockLocalStorage();
    sut = LocalStorageAdapter(localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(100);

  });

  test('Should call local storage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorage.deleteItem(key)).called(1);
    verify(localStorage.setItem(key, value)).called(1);
  });
}