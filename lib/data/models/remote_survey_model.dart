import '../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool isAnswered;

  RemoteSurveyModel({
    required this.id,
    required this.question,
    required this.date,
    required this.isAnswered,
  });

  factory RemoteSurveyModel.fromJson(Map json) {
    final isJsonValid = json.keys.toSet().containsAll([
      'id',
      'question',
      'date',
      'isAnswered',
    ]);
    if (!isJsonValid) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyModel(
      id: json['id'],
      question: json['question'],
      date: json['date'],
      isAnswered: json['isAnswered'],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        date: DateTime.parse(date),
        isAnswered: isAnswered,
      );
}
