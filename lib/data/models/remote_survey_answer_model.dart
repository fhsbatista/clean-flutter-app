import '../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteSurveyAnswerModel {
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;
  final String? image;

  RemoteSurveyAnswerModel({
    required this.answer,
    required this.isCurrentAccountAnswer,
    required this.percent,
    this.image,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
    final isJsonValid = json.keys.toSet().containsAll([
      'answer',
      'isCurrentAccountAnswer',
      'percent',
    ]);
    if (!isJsonValid) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyAnswerModel(
      answer: json['answer'],
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
      percent: json['percent'],
      image: json['image'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        answer: answer,
        isCurrentAnswer: isCurrentAccountAnswer,
        percent: percent,
        image: image,
      );
}
