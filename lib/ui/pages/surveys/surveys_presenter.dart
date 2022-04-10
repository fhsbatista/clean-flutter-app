import 'package:flutter/foundation.dart';
import 'package:fordev/ui/pages/pages.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;

  void loadData();
}
