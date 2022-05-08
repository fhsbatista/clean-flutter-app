import 'package:flutter/material.dart';
import '../../helpers/i18n/i18n.dart';
import '../../mixins/mixins.dart';
import 'splash_presenter.dart';

class SplashPage extends StatelessWidget with Navigation {
  const SplashPage(this.presenter);

  final SplashPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.strings.appTitle),
      ),
      body: Builder(
        builder: (context) {
          handleNavigation(presenter.navigateToStream, clear: true);
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
