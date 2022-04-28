import 'package:get/get.dart';

mixin Navigation {
  void handleNavigation(Stream<String?> stream, {bool clear = false}) {
    stream.listen((route) async {
      if (route?.isNotEmpty ?? false) {
        if (clear == true) {
          Get.offAllNamed(route!);
        } else {
          Get.toNamed(route!);
        }
      }
    });
  }
}
