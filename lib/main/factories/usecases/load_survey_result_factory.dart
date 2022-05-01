import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(cacheStorage: makeLocalStorageAdapter());
}

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthHttpAdapterDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(
  String surveyId,
) {
  return RemoteLoadSurveyResultWithLocalFallback(
    local: makeLocalLoadSurveyResult(surveyId),
    remote: makeRemoteLoadSurveyResult(surveyId), 
  );
}
