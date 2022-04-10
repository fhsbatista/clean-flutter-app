import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/i18n/i18n.dart';

import './components/components.dart';
import 'surveys.dart';

class SurveysPage extends StatefulWidget {
  SurveysPage(this.presenter);

  final SurveysPresenter presenter;

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  @override
  Widget build(BuildContext context) {
    widget.presenter.loadData();
    return Scaffold(
      appBar: AppBar(title: Text(I18n.strings.surveys)),
      body: Builder(builder: (context) {
        widget.presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });
        return StreamBuilder<List<SurveyViewModel>>(
          stream: widget.presenter.surveysStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        child: Text(I18n.strings.reload),
                        onPressed: widget.presenter.loadData,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    aspectRatio: 1,
                  ),
                  items: snapshot.data?.map(
                    (viewModel) {
                      return SurveyItem(viewModel);
                    },
                  ).toList(),
                ),
              );
            }
            return SizedBox.shrink();
          },
        );
      }),
    );
  }
}
