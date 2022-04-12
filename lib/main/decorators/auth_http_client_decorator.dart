import 'package:fordev/data/cache/fetch_secure_cache_storage.dart';

class AuthHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthHttpClientDecorator(this.fetchSecureCacheStorage);

  Future<void> request({
    required String url,
    required String method,
    Map headers = const {},
    Map body = const {},
  }) async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
