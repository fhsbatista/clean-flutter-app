import 'package:fordev/domain/entities/entities.dart';

import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({
    required this.url,
    required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final List<Map> response = await httpClient.request(
        url: url,
        method: 'get',
      );
      return response
          .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
          .toList();
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}
