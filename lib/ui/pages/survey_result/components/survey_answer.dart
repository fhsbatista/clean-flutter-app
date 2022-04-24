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
        _row(context),
        _divider(),
      ],
    );
  }
  Container _row(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            viewModel.image != null ? _image() : const SizedBox.shrink(),
            _answer(),
            _percent(context),
            _checkIcon(),
          ],
        ),
      );
  }

  Divider _divider() => const Divider(height: 1);

  Text _percent(BuildContext context) {
    return Text(
      viewModel.percent,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }

  Expanded _answer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          viewModel.answer,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Image _image() {
    return Image.network(
      viewModel.image!,
      width: 80,
      height: 40,
    );
  }

  CheckIcon _checkIcon() {
    return viewModel.isCurrentAnswer ? ActiveCheckIcon() : DisabledCheckIcon();
  }
}
