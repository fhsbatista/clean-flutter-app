import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'splash_page_test.mocks.dart';

@GenerateMocks([SplashPresenter])
void main() {
  late SplashPresenter presenter;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSplashPresenter();
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => SplashPage(presenter: presenter),
          )
        ],
      ),
    );
  }

  testWidgets('Should present spinner on page load', (tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call LoadCurrentAccount on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });
}

class SplashPage extends StatelessWidget {
  const SplashPage({required this.presenter});

  final SplashPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('fordev'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

abstract class SplashPresenter {
  Future<void> loadCurrentAccount();
}
