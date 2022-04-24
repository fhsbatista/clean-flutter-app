import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/surveys/components/components.dart';

import '../surveys.dart';

class SurveyItemsList extends StatelessWidget {
  final List<SurveyViewModel> surveys;

  const SurveyItemsList(this.surveys);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
        items: surveys.map((viewModel) => SurveyItem(viewModel)).toList(),
      ),
    );
  }
}