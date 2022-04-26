import '../factories.dart';
import '../../decorators/decorators.dart';
import '../../../data/http/http.dart';

HttpClient makeAuthHttpAdapterDecorator() {
  return AuthHttpClientDecorator(
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    decoratee: makeHttpAdapter(),
    deleteSecureCacheStorage: makeSecureStorageAdapter(),
  );
}
