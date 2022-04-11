import 'package:fordev/data/cache/fetch_secure_cache_storage.dart';

class AuthHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthHttpClientDecorator(this.fetchSecureCacheStorage);

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
