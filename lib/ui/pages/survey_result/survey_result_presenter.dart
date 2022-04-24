import 'package:flutter/foundation.dart';

import 'survey_result.dart';


abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel> get surveyResultsStream;

  Future<void> loadData();
}
