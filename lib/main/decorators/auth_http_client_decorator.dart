import 'package:fordev/data/cache/fetch_secure_cache_storage.dart';

import '../../data/http/http.dart';

class AuthHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthHttpClientDecorator(this.fetchSecureCacheStorage, this.decoratee);

  Future<void> request({
    required String url,
    required String method,
    Map headers = const {},
    Map body = const {},
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    final headersWithAuth = {'x-access-token': token};
    await decoratee.request(
      url: url,
      method: method,
      headers: headersWithAuth,
      body: body,
    );
  }
}
