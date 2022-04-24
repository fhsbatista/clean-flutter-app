import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'survey_result_page_test.mocks.dart';

@GenerateMocks([SurveyResultPresenter])
void main() {
  late MockSurveyResultPresenter presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSurveyResultPresenter();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
          name: '/survey_result',
          page: () => SurveyResultPage(presenter),
        ),
        GetPage(
          name: '/fake_route',
          page: () => Scaffold(body: Text('fake page')),
        ),
      ],
    );
    //Para evitar problemas com caregamento do Image.network no widget.
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  testWidgets('Should call LoadSurveyResult on page load', (tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
}
