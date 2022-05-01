import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithFallback {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithFallback({
    required this.remote,
    required this.local,
  });

  Future<void> loadBySurvey(String surveyId) async {
    final survey = await remote.loadBySurvey(surveyId);
    local.save(survey);
  }
}
