import '../../domain/entities/entities.dart';
import '../http/http.dart';
import 'models.dart';

class RemoteSurveyResultModel {
  final String id;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    required this.id,
    required this.question,
    required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    final isJsonValid = json.keys.toSet().containsAll([
      'surveyId',
      'question',
      'answers',
    ]);
    if (!isJsonValid) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyResultModel(
      id: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<RemoteSurveyAnswerModel>(
              (json) => RemoteSurveyAnswerModel.fromJson(json))
          .toList(),
    );
  }

  SurveyResultEntity toEntity() {
    return SurveyResultEntity(
        id: id,
        question: question,
        answers: answers
            .map<SurveyAnswerEntity>((model) => model.toEntity())
            .toList(),
      );
  }
}
