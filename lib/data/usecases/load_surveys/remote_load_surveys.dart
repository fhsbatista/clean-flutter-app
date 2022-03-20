import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys implements LoadSurveys {
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
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.access_denied
          : DomainError.unexpected;
    }
  }
}
