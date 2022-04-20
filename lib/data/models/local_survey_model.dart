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

  factory LocalSurveyModel.fromEntity(SurveyEntity survey) {
    return LocalSurveyModel(
      id: survey.id,
      question: survey.question,
      date: survey.date.toIso8601String(),
      isAnswered: survey.isAnswered,
    );
  }

  SurveyEntity toEntity() => SurveyEntity( 
        id: id,
        question: question,
        date: DateTime.parse(date),
        isAnswered: isAnswered,
      );

  Map<String, String> toJson() => {
        'id': id,
        'question': question,
        'date': date,
        'didAnswer': isAnswered.toString(),
      };
}
