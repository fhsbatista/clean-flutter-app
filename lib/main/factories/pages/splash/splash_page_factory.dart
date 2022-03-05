import 'package:flutter/material.dart';
import 'package:fordev/main/factories/pages/splash/splash.dart';

import '../../../../ui/pages/pages.dart';

Widget makeSplashPage() {
  return SplashPage(makeGetxSplashPresenter());
}
