import 'package:localstorage/localstorage.dart';

import '../../../infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  final storage = LocalStorage('fordev');
  return LocalStorageAdapter(storage);
}
