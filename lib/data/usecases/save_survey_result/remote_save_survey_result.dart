import '../../http/http.dart';

class RemoteSaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({
    required this.url,
    required this.httpClient,
  });

  Future<void> save(String answer) async {
    httpClient.request(url: url, method: 'put', body: {'answer': answer});
  }
}
