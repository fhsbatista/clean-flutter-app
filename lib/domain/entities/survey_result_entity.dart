
import 'package:equatable/equatable.dart';

import 'entities.dart';

class SurveyResultEntity extends Equatable {
  final String id;
  final String question;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    required this.id,
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => [id, question, answers];
}
