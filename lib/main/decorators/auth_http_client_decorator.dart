import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthHttpClientDecorator(this.fetchSecureCacheStorage, this.decoratee);

  Future<dynamic> request({
    required String url,
    required String method,
    Map headers = const {},
    Map body = const {},
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authHeader = {'x-access-token': token};
      return decoratee.request(
        url: url,
        method: method,
        headers: {...headers, ...authHeader},
        body: body,
      );
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}
