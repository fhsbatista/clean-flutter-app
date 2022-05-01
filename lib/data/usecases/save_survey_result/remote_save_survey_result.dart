import 'package:fordev/data/models/remote_survey_result_model.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({
    required this.url,
    required this.httpClient,
  });

  Future<SurveyResultEntity> save(String answer) async {
    try {
      final json = await httpClient.request(
        url: url,
        method: 'put',
        body: {'answer': answer},
      );
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.access_denied
          : DomainError.unexpected;
    }
  }
}
