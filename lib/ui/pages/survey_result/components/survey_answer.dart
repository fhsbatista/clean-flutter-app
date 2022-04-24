import 'package:flutter/material.dart';

import '../survey_result.dart';
import 'components.dart';

class SurveyAnswer extends StatelessWidget {
  final SurveyAnswerViewModel viewModel;

  const SurveyAnswer(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              viewModel.image != null
                  ? Image.network(
                      viewModel.image!,
                      width: 80,
                      height: 40,
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    viewModel.answer,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                viewModel.percent,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              viewModel.isCurrentAnswer
                  ? ActiveCheckIcon()
                  : DisabledCheckIcon(),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}