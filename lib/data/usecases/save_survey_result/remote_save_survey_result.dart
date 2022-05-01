import 'package:fordev/domain/usecases/usecases.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
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
