import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final HttpClient decoratee;

  AuthHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
    required this.decoratee,
  });

  Future<dynamic> request({
    required String url,
    required String method,
    Map headers = const {},
    Map body = const {},
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetch('token');
      final authHeader = {'x-access-token': token};
      return decoratee.request(
        url: url,
        method: method,
        headers: {...headers, ...authHeader},
        body: body,
      );
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) {
        rethrow;
      } else {
        await deleteSecureCacheStorage.delete('token');
        throw HttpError.forbidden;
      }
    }
  }
}
