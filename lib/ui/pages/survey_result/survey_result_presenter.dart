import 'package:flutter/foundation.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;

  Future<void> loadData();
}
