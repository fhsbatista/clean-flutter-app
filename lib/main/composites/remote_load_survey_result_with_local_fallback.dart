import 'package:fordev/domain/helpers/helpers.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    required this.remote,
    required this.local,
  });

  Future<SurveyResultEntity> loadBySurvey(String surveyId) async {
    try {
      final survey = await remote.loadBySurvey(surveyId);
      await local.save(survey);
      return survey;
    } catch (error) {
      if (error == DomainError.access_denied) {
        rethrow;
      }
      await local.validate(surveyId);
      final survey = await local.loadBySurvey(surveyId);
      return survey;
    }
  }
}
