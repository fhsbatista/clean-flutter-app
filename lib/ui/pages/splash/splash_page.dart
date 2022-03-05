import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_presenter.dart';


class SplashPage extends StatelessWidget {
  const SplashPage(this.presenter);

  final SplashPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('fordev'),
      ),
      body: Builder(
        builder: (context) {
          presenter.navigateToStream.listen((route) {
            if (route?.isNotEmpty ?? false) {
              Get.offAllNamed(route!);
            }
          });
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}