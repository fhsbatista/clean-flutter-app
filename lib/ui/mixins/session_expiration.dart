import 'package:get/get.dart';

mixin SessionExpiration {
  void handleSessionExpiration(Stream<bool> stream) {
    stream.listen((isExpired) async {
      if (isExpired) {
        Get.offAllNamed('/login');
      }
    });
  }
}
