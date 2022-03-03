import 'package:fordev/main/factories/cache/local_storage_adapter_factory.dart';

import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
    saveSecureCacheStorage: makeLocalStorageAdapter(),
  );
}
