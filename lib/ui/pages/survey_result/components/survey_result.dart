import 'package:flutter/material.dart';

import '../survey_result.dart';
import 'components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final Function(String) onClick;

  const SurveyResult({
    required this.viewModel,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(viewModel.question);
        }
        return InkWell(
          onTap: onClick(viewModel.answers[index -1].answer),
          child: SurveyAnswer(viewModel.answers[index - 1]),
        );
      },
    );
  }
}
