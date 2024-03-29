import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../factories.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    saveSurveyResult: makeRemoteSaveSurveyResult(surveyId),
    surveyId: surveyId,
  );
}
