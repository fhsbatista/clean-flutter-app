import 'package:fordev/data/http/http_client.dart';
import 'package:fordev/domain/entities/entities.dart';

import '../../models/models.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({
    required this.url,
    required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    final List<Map> response = await httpClient.request(
      url: url,
      method: 'get',
    );
    return response
        .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}
