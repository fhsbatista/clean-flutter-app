import 'package:equatable/equatable.dart';

class SurveyEntity extends Equatable {
  final String id;
  final String question;
  final DateTime date;
  final bool isAnswered;

  SurveyEntity({
    required this.id,
    required this.question,
    required this.date,
    required this.isAnswered,
  });

  @override
  List<Object?> get props => [id, question, date, isAnswered];
}
