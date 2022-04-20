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

  setUp(() {
    localStorage = MockLocalStorage();
    sut = LocalStorageAdapter(localStorage);
  });

  test('Should call local storage with correct values', () async {
    final key = faker.randomGenerator.string(5);
    final value = faker.randomGenerator.string(100);

    await sut.save(key: key, value: value);

    verify(localStorage.setItem(key, value)).called(1);
  });
}