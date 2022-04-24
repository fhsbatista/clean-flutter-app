import 'package:flutter/foundation.dart';


abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<List<dynamic>> get surveyResultsStream;

  Future<void> loadData();
}
