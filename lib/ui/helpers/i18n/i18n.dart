import 'package:flutter/widgets.dart';

import './strings/strings.dart';

class I18n {
  static Translations strings = PtBr();

  static load(Locale locale) {
    switch (locale.toString()) {
      case 'en':
        strings = EnUs();
        break;
      case 'en_US':
        strings = EnUs();
        break;
      default:
        strings = PtBr();
        break;
    }
  }
}
