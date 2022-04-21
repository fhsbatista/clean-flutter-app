import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter {
  LocalStorageAdapter(this.localStorage);

  final LocalStorage localStorage;

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }

  Future<void> delete(String key) async {
    await localStorage.deleteItem(key);
  }

}