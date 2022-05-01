import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithFallback({
    required this.remote,
    required this.local,
  });

  Future<SurveyResultEntity> loadBySurvey(String surveyId) async {
    final survey = await remote.loadBySurvey(surveyId);
    await local.save(survey);
    return survey;
  }
}
