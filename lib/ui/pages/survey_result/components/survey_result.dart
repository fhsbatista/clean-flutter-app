import 'package:flutter/material.dart';

import '../survey_result.dart';
import 'components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(
              top: 40,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withAlpha(90),
            ),
            child: Text(viewModel.question),
          );
        }
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
                  viewModel.answers[index - 1].image != null
                      ? Image.network(
                          viewModel.answers[index - 1].image!,
                          width: 80,
                          height: 40,
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        viewModel.answers[index - 1].answer,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Text(
                    viewModel.answers[index - 1].percent,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  viewModel.answers[index - 1].isCurrentAnswer
                      ? ActiveCheckIcon()
                      : DisabledCheckIcon(),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}