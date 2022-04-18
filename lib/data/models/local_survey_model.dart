import '../../domain/entities/entities.dart';

class LocalSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool isAnswered;

  LocalSurveyModel({
    required this.id,
    required this.question,
    required this.date,
    required this.isAnswered,
  });

  factory LocalSurveyModel.fromJson(Map json) {
    return LocalSurveyModel(
      id: json['id'],
      question: json['question'],
      date: json['date'],
      isAnswered: json['didAnswer'].toLowerCase() == 'true',
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        date: DateTime.parse(date),
        isAnswered: isAnswered,
      );
}
