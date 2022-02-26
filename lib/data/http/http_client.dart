abstract class HttpClient {
  Future<String> request({
    required String url,
    required String method,
    Map body,
  });
}