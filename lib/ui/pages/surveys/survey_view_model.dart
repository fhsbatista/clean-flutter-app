import 'package:equatable/equatable.dart';

class SurveyViewModel extends Equatable {
  final String id;
  final String question;
  final String date;
  final bool isAnswered;

  SurveyViewModel({
    required this.id,
    required this.question,
    required this.date,
    required this.isAnswered,
  });

  @override
  List<Object?> get props => [id, question, date, isAnswered];
}
