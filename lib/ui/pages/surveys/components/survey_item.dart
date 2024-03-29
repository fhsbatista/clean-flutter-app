import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../surveys.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel viewModel;

  const SurveyItem(this.viewModel);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SurveysPresenter>(context);
    return InkWell(
      onTap: () => presenter.goToSurveyResult(surveyId: viewModel.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: viewModel.isAnswered
                ? Theme.of(context).secondaryHeaderColor
                : Theme.of(context).primaryColorDark,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 0,
                blurRadius: 3,
                color: Colors.black,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.date,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                viewModel.question,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
