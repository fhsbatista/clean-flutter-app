import '../../../data/usecases/usecases.dart';
import '../factories.dart';

RemoteSaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) {
  return RemoteSaveSurveyResult(
    httpClient: makeAuthHttpAdapterDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}

