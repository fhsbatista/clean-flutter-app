import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithFallback {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithFallback({required this.remote});

  Future<void> loadBySurvey(String surveyId) async {
    remote.loadBySurvey(surveyId);
  }
}
