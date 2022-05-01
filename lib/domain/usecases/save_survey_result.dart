
import '../entities/entities.dart';

abstract class SaveSurveyResult {
  Future<SurveyResultEntity> save(String answer);
}
