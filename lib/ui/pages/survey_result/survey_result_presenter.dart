import 'package:flutter/foundation.dart';

abstract class SurveyResultPresenter implements Listenable {
  Future<void> loadData();
}
